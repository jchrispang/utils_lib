function surface_connectome_connectivity = calc_surface_connectome_connectivity(surface, parc, adj)
% calc_surface_connectome_connectivity.m
%
% Calculate connectome-based connectivity on a surface matrix
%
% Input: surface                          : surface structure with fields
%                                           vertices and faces
%        parc                             : parcellation [Nx1]
%                                           N = number of vertices
%        adj                              : connectome adjacency matrix
%
% Output: surface_connectome_connectivity : surface conenctome-based connectivity matrix [NxN]
%
% Original: James Pang, Monash University, 2021

%%

num_vertices = size(surface.vertices, 1);
parcels = unique(parc(parc>0));
num_parcels = length(parcels);

surface_connectome_connectivity = zeros(num_vertices);

for parc_ind_1 = 1:num_parcels
    parcel_1 = parcels(parc_ind_1);
    ind_parcel_1 = find(parc==parcel_1);
    
    for parc_ind_2 = (parc_ind_1+1):num_parcels
        parcel_2 = parcels(parc_ind_2);
        ind_parcel_2 = find(parc==parcel_2);
        
        if adj(parcel_1, parcel_2) > 0
            surface_connectome_connectivity(ind_parcel_1,ind_parcel_2) = 1;
        end
    end
end
        
surface_connectome_connectivity = surface_connectome_connectivity + surface_connectome_connectivity';
surface_connectome_connectivity(surface_connectome_connectivity>0) = 1;
