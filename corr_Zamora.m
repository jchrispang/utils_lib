function corrmatrix = corr_Zamora(adjmatrix,coupling)
% Zamora-Lopez et al.'s method

% Compute the Q matrix
Qmatrix = expm(coupling*adjmatrix);

% Compute the covariance matrix
COVmatrix = Qmatrix.'*Qmatrix;

% Normalises a covariance matrix into a cross-correlation matrix.
% Calculate the normalization factor for each pair
diagvalues = diag(COVmatrix);
normmatrix = sqrt(diagvalues*diagvalues.');

% Return result
corrmatrix = COVmatrix./normmatrix;

end