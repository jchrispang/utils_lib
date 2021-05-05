function coeffs = decomposeEigenvectors(eigenvectors, data)
% decomposeEigenvectors.m
%
% Decompose eigenvectors and calculate coefficients of contribution of each
% vector
%
% Inputs: eigenvectors : eigenvectors [MxN]
%                        M = number of points, N = number of vectors
%         data         : surface vertex data [Mxdimensions]
%                        dimensions = number of dimensions
% Output: coeffs       : coefficient values [Nxdimensions]
%
% Original: James Pang, Monash University, 2021

%%

[M, N] = size(eigenvectors);
[dim1, dim2] = size(data);

if dim1<dim2 && dim1<=3
    dimensions = dim1;
    data = data';
elseif dim2<dim1 && dim2<=3
    dimensions = dim2;
end

coeffs = zeros(N, dimensions);

PSI = eigenvectors;
for dim = 1:dimensions
    coeffs(:,dim) = (PSI.'*PSI)\(PSI.'*data(:,dim));
end


end


% coefsx_l=decomposeEigenFunction(eigvecs.lh, vertex.lh(1,:)');
% coefsy_l=decomposeEigenFunction(eigvecs.lh, vertex.lh(2,:)');
% coefsz_l=decomposeEigenFunction(eigvecs.lh, vertex.lh(3,:)');