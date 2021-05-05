function [C, Cmax, coupling_max, Corr_mean] = func_complexity(W,nbins,coupling_vec,method)
% func_complexity.m
%
% Calculate functional complexity based on Zamora-Lopez et al., Sci Rep
% implementated as per python code here:
% https://github.com/gorkazl/pyGAlib/blob/master/galib_extra.py
%
% Inputs: W             : connectivtiy matrix [NxN]
%         nbins         : number of histogram bins for the FC complexity (float)
%         coupling_vec  : coupling values (vector)
%         method        : method to calculate correlation matrix (string)
%                         'Zamora' or 'Tononi'
%
% Outputs: C            : complexity values (vector)
%          Cmax         : maximum complexity (float)
%          coupling_max : coupling of maximum complexity (float)
%          Corr_mean    : mean correlation (vector)
%
% Original: James Roberts, QIMR Berghofer
% Edited: James Pang, QIMR Berghofer, 2020

%%

if nargin<4
    method = 'Zamora';
end
if nargin<3
    coupling_vec = linspace(0, 10, 51);
end
if nargin<2
    nbins = 100;
end

C = zeros(1,length(coupling_vec));
Corr_mean = zeros(1,length(coupling_vec));

ut = triu(ones(size(W,1)),1)>0;

if strcmpi(method, 'Zamora')
    corrfun = @corr_exp;
elseif strcmpi(method, 'Tononi')
    corrfun = @corr_OU;
end

for m=1:length(coupling_vec)
    coupling = coupling_vec(m);
    corrmatrix = corrfun(W,coupling);
    C(m) = complexity(corrmatrix(ut),nbins);
    Corr_mean(m) = mean(corrmatrix(ut), 'all');
end

Cmax = max(C);
coupling_max = coupling_vec(C==Cmax);

end

function C = complexity(corrvals,nbins)
% Complexity from FC matrix values
binedges = linspace(0,1,nbins+1);
probs = histcounts(corrvals,binedges,'normalization','probability');
C = 1-sum(abs(probs-1/nbins))/(2*(nbins-1)/nbins);
end

function corrmatrix = corr_exp(W,coupling)
% Zamora-Lopez et al.'s method

% Compute the Q matrix
Qmatrix = expm(coupling*W);

% Compute the covariance matrix
COVmatrix = Qmatrix.'*Qmatrix;

% Normalises a covariance matrix into a cross-correlation matrix.
% Calculate the normalization factor for each pair
diagvalues = diag(COVmatrix);
normmatrix = sqrt(diagvalues*diagvalues.');

% Return result
corrmatrix = COVmatrix./normmatrix;

end

function corrmatrix = corr_OU(W,coupling)
% Tononi, Sporns, and Edelman's method.

% Construct the uncorrelated noise vector (diagonal matrix)
N = size(W,1);

% Compute the Q matrix
Qmatrix = inv(eye(N) - coupling*W);

% Compute the covariance matrix
COVmatrix = Qmatrix.'*Qmatrix;

% Normalises a covariance matrix into a cross-correlation matrix.
% Calculate the normalization factor for each pair
diagvalues = diag(COVmatrix);
normmatrix = sqrt(diagvalues*diagvalues.');

% Return result
corrmatrix = COVmatrix./normmatrix;

end
