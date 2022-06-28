function data_rescaled = calc_rescale(data, fmin, fmax, direction)
% calc_rescale.m
%
% Rescale data to range [fmin, fmax]
%
% Inputs: data_input    : data to be rescaled [NxM]
%         fmin          : minimum value (float)
%         fmax          : maximum value (float)
%         direction     : direction of proportionality (string)
%                         'positive' - directly proportional
%                         'negative' - inversely proportional
%
% Output: data_rescaled : rescaled data [NxM]
%
% Original: James Pang, Monash University, 2022

%%

if nargin < 4
    direction = 'positive';
end

[N,~] = size(data);

switch direction
    case 'positive'
        data_rescaled = (fmin + (fmax - fmin)*(data - repmat(min(data,[],1), N, 1))./(repmat(max(data,[],1), N, 1) - repmat(min(data,[],1), N, 1)));
    case 'negative'
        data_rescaled = (fmax - (fmax - fmin)*(data - repmat(min(data,[],1), N, 1))./(repmat(max(data,[],1), N, 1) - repmat(min(data,[],1), N, 1)));
end
