function corrmatrix = corr_Tononi(adjmatrix,coupling)
% Tononi, Sporns, and Edelman's method.

% Construct the uncorrelated noise vector (diagonal matrix)
N = size(adjmatrix,1);

% Compute the Q matrix
Qmatrix = inv(eye(N) - coupling*adjmatrix);

% Compute the covariance matrix
COVmatrix = Qmatrix.'*Qmatrix;

% Normalises a covariance matrix into a cross-correlation matrix.
% Calculate the normalization factor for each pair
diagvalues = diag(COVmatrix);
normmatrix = sqrt(diagvalues*diagvalues.');

% Return result
corrmatrix = COVmatrix./normmatrix;

end
