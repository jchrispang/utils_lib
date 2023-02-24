function sim_activity = model_BOLD_balloon_temp(ext_input, param, method)
% model_BOLD_balloon.m
%
% Simulate bal on a surface or nodes.
%
% Inputs: ext_input    : spatiotemporal external input [V x T]
%                        V = number or vertices or nodes
%                        T = number of time points
%         param        : model parameters (struct)
%                        Create instance using loadParameters_balloon_func.m
%         method       : method for calculating the activity (string)
%                        ODE = via solving ODEs
%                        Fourier = via solving Fourier transform
%
% Output: sim_activity : simulated BOLD activity [V x T]
%
% Original: James Pang, Monash University, 2022

%%

if nargin<3
    method = 'ODE';
end

num_points = size(ext_input,1);

switch method
    case 'ODE'
    
        % initialize activity vectors
        sol.z = zeros(num_points, length(param.T));
        sol.f = zeros(num_points, length(param.T));
        sol.v = zeros(num_points, length(param.T));
        sol.q = zeros(num_points, length(param.T));
        sol.BOLD = zeros(num_points, length(param.T));

        % setting initial condition
        z = 0.001*ones(num_points,1);
        f = 0.001*ones(num_points,1);
        v = 0.001*ones(num_points,1);
        q = 0.001*ones(num_points,1);
        F0 = [z, f, v, q];
        
        F = F0;
        sol.z(:,1) = F(:,1);
        sol.f(:,1) = F(:,2);
        sol.v(:,1) = F(:,3);
        sol.q(:,1) = F(:,4);
        
        for k = 2:length(param.T)
            dF = balloon_ODE(ext_input(:,k-1), F, param);
            F = F + dF*param.tstep;
            sol.z(:,k) = F(:,1);
            sol.f(:,k) = F(:,2);
            sol.v(:,k) = F(:,3);
            sol.q(:,k) = F(:,4);
        end

        sol.BOLD = 100*param.V0*(param.k1*(1 - sol.q) + param.k2*(1 - sol.q./sol.v) + param.k3*(1 - sol.v));

        sim_activity = sol.BOLD;
        
    case 'Fourier'
        
        % append time vector with negative values to have a zero center
        T_append = [-param.tmax:param.tstep:param.tmax];
        Nt = length(T_append);
        t0_ind = dsearchn(T_append', 0);
        
        % mode decomposition of external input
        ext_input_coeffs_temp = calc_eigendecomposition(ext_input, eig_vec, 'matrix');

        % append external input coefficients for negative time values
        ext_input_coeffs = zeros(num_modes, Nt);
        ext_input_coeffs(:,t0_ind:end) = ext_input_coeffs_temp;
        
        % initialize simulated activity vector
        sim_activity = zeros(num_modes, size(ext_input_coeffs,2));

        for mode_ind = 1:num_modes
            mode_coeff = ext_input_coeffs(mode_ind,:);
            lambda = eig_val(mode_ind);

            yout = wave_Fourier(mode_coeff, lambda, T_append, param);

            sim_activity(mode_ind,:) = yout;
        end
        
        sim_activity = sim_activity(:,t0_ind:end);
end

end

function dF = balloon_ODE(S, F, param)
% balloon_ODE.m
%
% Calculate the temporal activity by solving an ODE.
%
% Inputs: S          : spatiotemporal external input [V x 1]
%         F          : solutions at one time point
%         param      : model parameters (struct)
%
% Output: dF         : time derivative of variables [4 x 1]
%
% Original: James Pang, Monash University, 2022

z = F(:,1);
f = F(:,2);
v = F(:,3);
q = F(:,4);

dF(:,1) = S - param.kappa*z - param.gamma*(f - 1);
dF(:,2) = z;
dF(:,3) = (1/param.tau)*(f - v.^(1/param.alpha));
dF(:,4) = (1/param.tau)*((f/param.rho).*(1 - (1 - param.rho).^(1./f)) - q.*v.^(1/param.alpha - 1));

end

function out = wave_Fourier(mode_coeff, lambda, T, param)
% wave_Fourier.m
%
% Calculate the temporal activity of one mode via Fourier transform.
%
% Inputs: mode_coeff : coefficient of the mode [1 x T]
%         lambda     : eigenvalue of the mode (float)
%         T          : time vector with zero center [1 x T]
%         param      : model parameters (struct)
%
% Output: out        : activity [1 x T]
%
% Original: James Pang, Monash University, 2022

Nt = length(T);
Nw = Nt;
wsamp = 1/mean(param.tstep)*2*pi;
wMat = (-1).^(1:Nw);
jvec = 0:Nw-1;
w = (wsamp)*1/Nw*(jvec - Nw/2);

% mode_coeff_fft = ctfft(mode_coeff, param.T);	
mode_coeff_fft = coord2freq_1D(mode_coeff, w);	

out_fft = param.gamma_s^2*mode_coeff_fft./(-w.^2 - 2*1i*w*param.gamma_s + param.gamma_s^2*(1 + param.r_s^2*lambda));

% calculate inverse Fourier transform
out = real(freq2coord_1D(out_fft, w));

end



