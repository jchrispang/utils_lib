function S = calc_eta_squared(data, gm_mask, parc)
% calc_eta_squared.m
%
% Calculate similarity matrix S between subcortical voxels based on the 
% eta squared coefficient
%
% Inputs: data    : fMRI data [Txnum_gray]
%                        T = length of time
%                        num_gray = number of gray matter voxels
%         gm_mask : volume of gray matter mask (3D array)
%         parc    : volume of parcellation (3D array)
%
% Output: S       : similarity matrix
%
% Original: James Pang, Monash University, 2021
%
% Adopted from Tian et al.
% (https://github.com/yetianmed/subcortex/blob/master/functions/compute_similarity.m)

%%
warning off

ind_gm = find(gm_mask);
ind_parc = find(parc);
ind_gm_parc = dsearchn(ind_gm, ind_parc);
T = size(data,1);

% detrend (demean) and make std=1
data_detrend = detrend(data,'constant');
data_detrend = data_detrend./repmat(std(data_detrend),T,1);

% get parcellation time series
data_parc = data_detrend(:, ind_gm_parc);

if ~any((isnan(data_detrend(:)))) % Make sure that all voxels contain no nan
    [U,S,~] = svd(data_detrend,'econ');
    a = U*S;
    a = a(:,1:end-1);
    
    % detrend (demean) and make std=1
    a = detrend(a,'constant');
    a = a./repmat(std(a),T,1);
    
    % calculate correlation
    corr_raw = data_parc'*a;
    corr_raw = corr_raw/T;
    corr_z = atanh(corr_raw);
    corr_z = corr_z(:, all(~isnan(corr_z)));
    
    clear a
    
    % calculate similarity matrix
    S = eta_squared(corr_z);
    S = single(S);
    clear zpc
else
    fprintf('Error: NAN presented,check your mask\n')
    S = [];
end

end

function eta = eta_squared(corr_z)
% Input: z    : z-transformed correlation matrix
%
% Output: eta : eta squared matrix
%
% Original: James Pang, Monash University, 2021
%
% Adopted from Tian et al.
% (https://github.com/yetianmed/subcortex/blob/master/functions/eta_squared.m)

N = size(corr_z,1); 
eta = zeros(N, N); 

parfor i = 1:N
    mu = (repmat(corr_z(i,:),N,1) + corr_z)/2; 
    mu_bar = mean(mu,2); 
    numerator = sum((repmat(corr_z(i,:),N,1) - mu).^2 + (corr_z - mu).^2, 2); 
    denominator = sum((repmat(corr_z(i,:),N,1) - mu_bar).^2 + (corr_z - mu_bar).^2, 2); 
    eta(:, i) = 1 - numerator./denominator;
end

end


