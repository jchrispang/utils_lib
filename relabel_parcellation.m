function parc_relabel = relabel_parcellation(parc, start_val, parcels)
% relabel_parcellation.m
%
% Relabel parcellation file to have consecutive values
%
% Inputs: parc         : volume (3d array) or surface (1d array) of parcellation
%         start_val    : starting value of the relabeled parcellation (integer)
%         parcels      : original parcel labels [vector]
%
% Output: parc_relabel : relabelled parcellation
%
% Original: James Pang, Monash University, 2021

%%

if nargin<3
    parcels = unique(parc(parc>0));
end
if nargin<2
    start_val = 1;
end

num_parcels = length(parcels);

parc_relabel = zeros(size(parc));

counter = start_val;

for parcel_ind = 1:num_parcels
    parcel_interest = parcels(parcel_ind);

    ind_parcel = find(parc==parcel_interest);
    
    parc_relabel(ind_parcel) = counter;
    
    counter = counter+1;
end