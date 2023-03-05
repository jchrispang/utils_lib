function coeffs = calc_eigendecomposition(data, eigenvectors, method)
% calc_eigendecomposition.m
%
% Decompose data using eigenvectors and calculate the coefficient of 
% contribution of each vector
%
% Inputs: data         : data [MxP]
%                        M = number of points, P = number of independent data
%         eigenvectors : eigenvectors [MxN]
%                        M = number of points, N = number of eigenvectors
%         method       : type of calculation
%                        'matrix', 'matrix_separate', 'regression'
% Output: coeffs       : coefficient values [NxP]
%
% Original: James Pang, Monash University, 2022

%%

warning('off')

[M,P] = size(data);
[~,Norig] = size(eigenvectors);
coeffs = zeros(Norig,P);

[~,eigenvectors_unique_ind,~] = unique(eigenvectors', 'stable', 'row');
eigenvectors_unique_ind = eigenvectors_unique_ind';
eigenvectors_nonzero_ind = find(~all(eigenvectors==0,1));
eigenvectors_keep_ind = sort(intersect(eigenvectors_unique_ind, eigenvectors_nonzero_ind));

N = length(eigenvectors_keep_ind);
eigenvectors = eigenvectors(:,eigenvectors_keep_ind);


% eigenvectors_nonzeros = ~all(eigenvectors==0,1);
% N = sum(eigenvectors_nonzeros);
% 
% coeffs = zeros(Norig,P);
% eigenvectors = eigenvectors(:,eigenvectors_nonzeros);

if nargin<3
    method = 'matrix';
end

switch method
    case 'matrix'
        coeffs_temp = (eigenvectors.'*eigenvectors)\(eigenvectors.'*data);
    case 'matrix_separate'
        coeffs_temp = zeros(N,P);
        
        for p = 1:P
            coeffs_temp(:,p) = (eigenvectors.'*eigenvectors)\(eigenvectors.'*data(:,p));
        end
    case 'regression'
        coeffs_temp = zeros(N,P);
        
        for p = 1:P
            coeffs_temp(:,p) = regress(data(:,p), eigenvectors);
        end
end
   
% coeffs(eigenvectors_nonzeros,:) = coeffs_temp;
coeffs(eigenvectors_keep_ind,:) = coeffs_temp;

end