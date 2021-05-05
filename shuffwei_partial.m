function R=shuffwei_partial(W,frac)
%  R = shuffwei_partial(W,frac)
% Shuffle a fraction frac of the weights in connectivity matrix W to give
% random matrix R, preserving adjacency matrix (i.e., zeros do not move).
%
% Inputs
% W         = weighted connectivity matrix
% frac      = scalar 0<frac<=1, shuffle this fraction of edges
%
% Outputs
% R         = random surrogate preserving weights 
%
%
% References: Gollo et al. (2018) Nature Neuroscience.
%             Roberts et al. (2016) NeuroImage 124:379-393.
%
% J Roberts, L Gollo
% QIMR Berghofer, 2018

nzi=find(W~=0); % nonzero indices
w=W(nzi); % nonzero weights
nedges=length(nzi);
subsetsize=round(frac*nedges);
shuffsubseti=randsample(nedges,subsetsize); % choose a random subset
shuffsubset=w(shuffsubseti);
shuffsubset=shuffsubset(randperm(subsetsize)); % shuffle the subset
r=w;
r(shuffsubseti)=shuffsubset;
R=zeros(size(W));
R(nzi)=r;