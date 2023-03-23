function [fig, varargout] = draw_volume_parcellation(volume_to_plot, parc, cmap, camera_view, markersize)
% draw_volume_bluewhitered.m
%
% Draw data on 3D volume using blue-white-red colormap for
% negative-zero-positive values
%
% Inputs: volume_to_plot : volume of mask in nifti format (3D array)
%         parc           : parcellation in nifti format (3D array)
%         cmap           : colormap [Nx3]
%                          N = number of colors
%         camera_view    : camera view angles [1x2]
%                          azimuth and elevation
%
% Output: fig            : figure handle
%
% Original: James Pang, Monash University, 2023

%%
parc_interest = relabel_parcellation(parc, 1);
parcels = unique(parc_interest(parc_interest>0));
num_parcels = length(parcels);

if nargin<5
    markersize = 80;
end

if nargin<4
    camera_view = [-27.5 40];
end

if nargin<3
    cmap = cbrewer('qual', 'Paired', num_parcels+2*round(num_parcels/10) , 'pchip');
    cmap = cmap(1:num_parcels,:);
end

% extract mask coordinates
ind = find(volume_to_plot~=0);
[y,x,z] = ind2sub(size(volume_to_plot), ind);
coords = [x,y,z];

% extract voxels in parc that match the mask
parc_temp = parc_interest(ind);

new_map = zeros(length(parc_temp),3);
for parcel_ind = 1:length(parcels)
    num_voxels_parcel = sum(parc_temp==parcel_ind,'all');
    new_map(parc_temp==parcel_ind,:) = repmat(cmap(parcel_ind,:), num_voxels_parcel, 1);
end

[~, sort_ind] = sort(parc_temp, 'ascend');

fig = figure;
set(fig, 'Position', get(fig, 'Position').*[0 0 0.6 0.6]+[200 200 0 0])
ax = axes('Position', [0.01 0.01 0.98 0.98]);
obj1 = scatter3(coords(sort_ind,1), coords(sort_ind,2), coords(sort_ind,3), markersize, new_map(sort_ind,:), 'filled');
set(ax, 'xlim', [min(coords(sort_ind,1)), max(coords(sort_ind,1))], ...
        'ylim', [min(coords(sort_ind,2)), max(coords(sort_ind,2))], ...
        'zlim', [min(coords(sort_ind,3)), max(coords(sort_ind,3))])
axis square
view(camera_view)
axis off
        
varargout{1} = obj1;

