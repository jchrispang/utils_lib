function S = calc_cortical_fingerprint(data, data_type, mask)
% calc_cortical_fingerprint.m
%
% Calculate cortical connectivity fingerprint within a mask
%
% Inputs: data       : data to calculate connectivity fingerprint from
%         data_type  : type of data (string)
%                      'timeseries', 'zFC', 'FC'
%         mask       : mask [Vx1]
%                      V = number of vertices
%
% Output: S          : connectivity fingerprint [VxV]
%                      V = number of vertices
%
% Original: James Pang, Monash University, 2021

%%

warning('off', 'all')

ind_mask = find(mask);
num_mask_vertices = length(ind_mask);

size_data = size(data);
if strcmpi(data_type, 'timeseries')
    if size_data(1) > size_data(2)
        num_vertices = size_data(1);
        T = size_data(2);
        
        data_normalized = utils.calc_normalize_timeseries(data(ind_mask,:)');
        data_normalized(isnan(data_normalized)) = 0;

        FC = data_normalized'*data_normalized;
        
    elseif size_data(1) < size_data(2)
        num_vertices = size_data(2);
        T = size_data(1);
        
        data_normalized = utils.calc_normalize_timeseries(data(:,ind_mask));
        data_normalized(isnan(data_normalized)) = 0;

        FC = data_normalized'*data_normalized;
    end
    
    FC = FC/T;
    zFC = atanh(FC);
    
elseif strcmpi(data_type, 'zFC')
    num_vertices = size_data(1);
    
    zFC = data(ind_mask,ind_mask);
elseif strcmpi(data_type, 'FC')
    num_vertices = size_data(1);
    
    zFC = atanh(data(ind_mask,ind_mask));
end
zFC(isnan(zFC)) = 0;

Stemp = zeros(num_mask_vertices, num_mask_vertices);
    
for v = 1:num_mask_vertices
    fprintf('Processing vertex = %i\n', v)
    mu = (repmat(zFC(v,:),num_mask_vertices,1) + zFC)/2; 
    mu_bar = mean(mu,2); 
    numerator = sum((repmat(zFC(v,:),num_mask_vertices,1) - mu).^2 + (zFC - mu).^2, 2); 
    denominator = sum((repmat(zFC(v,:),num_mask_vertices,1) - mu_bar).^2 + (zFC - mu_bar).^2, 2); 
    Stemp(:, v) = 1 - numerator./denominator;
end

S = zeros(num_vertices, num_vertices); 
S(ind_mask,ind_mask) = Stemp;

