function stats = calc_response_stats_version1_2(x, F, F_transition)
% calc_response_stats.m
%
% Calculate various statistics of F.
%
% Inputs: x             : x vector (vector)
%         F             : function value at x [vector]
%         F_transition  : transition value of F (float)
%         x_peak        : x value of some peak (float)
%
% Output: stats         : statistics (struct)
%
% Original: James Pang, QIMR Berghofer, 2020

%%

if nargin<3
    F_transition = 0.3;
end

for j=1:size(F,1)
    stats.max(j,1) = max(F(j,:));
    stats.min(j,1) = min(F(j,:));
    stats.Fval_10(j,1) = stats.min(j) + 0.1*(stats.max(j)-stats.min(j));
    stats.Fval_90(j,1) = stats.min(j) + 0.9*(stats.max(j)-stats.min(j));
    stats.xval_10(j,1) = x(dsearchn(F(j,:)', stats.Fval_10(j)));
    stats.xval_90(j,1) = x(dsearchn(F(j,:)', stats.Fval_90(j)));
    stats.dynamic_range(j,1) = 10*log10(stats.xval_90(j)/stats.xval_10(j));
    stats.xval_transition(j,1) = x(dsearchn(F(j,:)', F_transition));
%     stats.Fval_xpeak(j,1) = F(j,dsearchn(x', x_peak));
    
    HillOutput = Hill(x,F(j,:),4,1,1,0.4,0);
    stats.Hill_slope(j,1) = HillOutput{2}(2);
    
end


