function matrix_triu_vals = extract_matrix_triu_vals(A, k)
% extract_matrix_triu_vals.m
%
% Get values on and above the kth diagonal of matrix A
%
% Inputs: A                    : matrix [NxN]
%         k                    : diagonals to include [int]
%                                k >= 0
%
% Output: matrix_triu_vals     : element values [vector]
%
% Original: James Pang, QIMR Berghofer, 2020

%%

temp = ones(size(A));
triu_indices = find(triu(temp,k));

matrix_triu_vals = A(triu_indices);