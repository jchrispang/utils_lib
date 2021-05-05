function [param, y_fit] = fit_sigmoid(x, y, type, param_initial)
% fit_sigmoid.m
%
% Fit a sigmoid function to y(x).
%
% Inputs: x             : x data [vector]
%         y             : y data [vector]
%         type          : type of sigmoid function [string]
%                         Possible choices:
%                         1. 'logistic' 
%                            y = param(1) + param(2)/(1 + exp(-param(3)*(x - param(4))))
%                            Note: param(1) represents the y-intercept
%                                  param(2) represents the y-scale
%                                  param(3) represents the slope of the curve
%                                  param(4) represents the half-way point
%                         2. 'Hill'
%                            y = param(1) + (param(2)*x^param(3))/(param(4)^param(3) + x^param(3))
%                            Note: param(1) represents the y-intercept
%                                  param(2) represents the y-scale
%                                  param(3) represents the slope of the curve
%                                  param(4) represents the half-way point                
%         param_initial : initial guess of parameter values [vector]
%
% Outputs: param  : parameter values [vector]
%          y_fit  : fitted y values [vector]
%
% Example:
% >> x = 0:0.01:10;
% >> y = 2./(1+exp(-5*(x-5))) + 0.1*randn(size(x));
% >> type = 'logistic';
% >> param_initial = [1, 1, 1, 1];
% >> [param, y_fit] = fit_sigmoid(x, y, type, param_initial);
%
% Original: James Pang, QIMR Berghofer, 2020

%%

if nargin<4
    param_initial = [1,1,1,1];
end

if strcmpi(type, 'logistic')
    F = @(param, x) param(1) + param(2)./(1 + exp(-param(3)*(x - param(4))));
elseif strcmpi(type, 'Hill')
    F = @(param, x) param(1) + (param(2)*x.^param(3))./(param(4)^param(3) + x.^param(3));
end
    
% least squares fitting
options = optimoptions('lsqcurvefit','Display','off');
param = lsqcurvefit(F, param_initial, x, y, [], [], options); 
y_fit = F(param, x);


% sample visualization of data and fit
% figure;
% scatter(x, y, 'k');
% hold on;
% plot(x, y_fit, 'r-', 'linewidth', 2);
% hold off;
