function R = prune_partial(A, num_edges)
% prune_partial.m
%
% Remove defined number of edges (num_edges) from connectivity matrix A
%
% Inputs: A          : connectivity matrix [NxN]
%         num_edges  : number of edges to be removed in the upper triangular matrix (float)
%
% Output: R          : pruned network [NxN]
%
% Original: James Pang, QIMR Berghofer, 2020

%%

A_triu = triu(A,1);

index_edges_to_consider = find(A_triu~=0);
num_edges_to_consider = length(index_edges_to_consider);

counter_edges_to_remove = randsample(num_edges_to_consider, num_edges);
index_edges_to_remove = index_edges_to_consider(counter_edges_to_remove);

R = A_triu;
R(index_edges_to_remove) = 0;

R = R+R';

