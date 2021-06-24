function R = randomize_partial(A, B, frac)
% randomize_partial.m
%
% Shuffle a fraction frac of the weights in connectivity matrix A to give
% random matrix R, avoiding the edges in B.
%
% Inputs: A     : connectivity matrix [NxN]
%         B     : matrix with edges to avoid [NxN]
%         frac  : fraction of edges to shuffle (float)
%                 0 < frac < 1
%
% Output: R     : randomized network [NxN]
%
% Original: James Pang, QIMR Berghofer, 2020

%%

if nargin<3
    frac = 1;
end

B(B~=0) = 1;

A_triu = triu(A,1);
B_triu = triu(B,1);

temp = ones(size(A));
triu_indices = find(triu(temp,1));

index_edges_to_avoid = find(B_triu~=0);
index_edges_to_consider = find(A_triu~=0 & B_triu==0);

num_edges_to_consider = length(index_edges_to_consider);
num_edges_to_randomize = round(frac*num_edges_to_consider);

counter_edges_to_randomize = randsample(num_edges_to_consider, num_edges_to_randomize);
index_edges_to_randomize = index_edges_to_consider(counter_edges_to_randomize);

index_edges_to_avoid = [index_edges_to_avoid; setdiff(index_edges_to_consider,index_edges_to_randomize)];

index_edges_available = setdiff(triu_indices, index_edges_to_avoid);

num_edges_available = length(index_edges_available);

counter_edges_chosen = randsample(num_edges_available, num_edges_to_randomize);
index_edges_chosen = index_edges_available(counter_edges_chosen);

A_edges_to_randomize = A(index_edges_to_randomize);

R = zeros(size(A));
R(index_edges_to_avoid) = A(index_edges_to_avoid);
R(index_edges_chosen) = A_edges_to_randomize;

R = R+R';

