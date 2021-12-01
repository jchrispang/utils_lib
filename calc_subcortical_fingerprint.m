function S = calc_subcortical_fingerprint(data, data_type)
% calc_subcortical_fingerprint.m
%
% Calculate subcortical connectivity fingerprint within a mask
%
% Inputs: data       : data to calculate connectivity fingerprint from
%         data_type  : type of data (string)
%                      'timeseries', 'zFC', 'FC'
%
% Output: S          : connectivity fingerprint [VxV]
%                      V = number of voxels
%
% Original: James Pang, Monash University, 2021

%%

warning('off', 'all')

size_data = size(data);
if strcmpi(data_type, 'timeseries')
    if size_data(1) > size_data(2)
        num_voxels = size_data(1);
        T = size_data(2);
        
        data_normalized = utils.calc_normalize_timeseries(data');
        data_normalized(isnan(data_normalized)) = 0;

        FC = data_normalized'*data_normalized;
        
    elseif size_data(1) < size_data(2)
        num_voxels = size_data(2);
        T = size_data(1);
        
        data_normalized = utils.calc_normalize_timeseries(data);
        data_normalized(isnan(data_normalized)) = 0;

        FC = data_normalized'*data_normalized;
    end
    
    FC = FC/T;
    zFC = atanh(FC);
    
elseif strcmpi(data_type, 'zFC')
    num_voxels = size_data(1);
    
    zFC = data;
elseif strcmpi(data_type, 'FC')
    num_voxels = size_data(1);
    
    zFC = atanh(data);
end
zFC(isnan(zFC)) = 0;

S = zeros(num_voxels, num_voxels);
    
parfor v = 1:num_voxels
    fprintf('Processing voxels = %i\n', v)
    mu = (repmat(zFC(v,:),num_voxels,1) + zFC)/2; 
    mu_bar = mean(mu,2); 
    numerator = sum((repmat(zFC(v,:),num_voxels,1) - mu).^2 + (zFC - mu).^2, 2); 
    denominator = sum((repmat(zFC(v,:),num_voxels,1) - mu_bar).^2 + (zFC - mu_bar).^2, 2); 
    S(:, v) = 1 - numerator./denominator;
end

