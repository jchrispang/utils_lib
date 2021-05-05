function [fig, cbar] = draw_internode_brainNetworks_horizontalSnapshots(connectome, thres, frac_vec, frac_interest, ...
                                    node_interest, nodeLocations, markersize, node_interest_data, ...
                                    node_interest_cmap, node_interest_markersize, edge_color, slice, ...
                                    cbar_limits, cbar_label, fontsize_label, fontsize_axis)
% draw_internode_brainNetworks_horizontalSnapshot.m
%
% Draw horizontally oriented snapshots of the data and network on a scatter plot
% of brain nodes for a particular view slice
%
% Inputs: connectome               : weighted connectivity matrix [NxN]
%         thres                    : fraction of top weights to show in (float)
%                                    0 = no weights preserved
%                                    1 = all weights preserved
%         frac_vec                 : vector of rewiring fraction [1 x nfrac]
%         frac_interest            : vector of selected fractions [1 x nfrac]
%         node_interest            : nodes to highlight [1 x M]
%         nodeLocations            : 3D locations of the nodes [N x 3]
%         markersize               : uniform size of the nodes (float)
%         node_interest_data       : properties of node_interest [M x nfrac]
%         node_interest_cmap       : colormap of node_interest_data [M x 3]
%         node_interest_markersize : markersize of node_interest [float] 
%         edge_color               : color of edges (string) or [1x3]
%         slice                    : view slice (string)
%                                    'axial', 'sagittal_left', 'sagittal_right',
%                                    'coronal'
%         cbar_limits              : limits of colorbar [1x2]
%         cbar_label               : label of colorbar 
%         fontsize_label           : fontsize of labels
%         fontsize_axis            : fontsize of axis
% Outputs: fig                     : figure handle
%          cbar                    : colorbar handle
%
% Original: James Pang, QIMR Berghofer, 2020

%%

nfrac = length(frac_vec);
N = size(nodeLocations,1);
M = size(node_interest_data,1);

if nargin<15
    fontsize_axis = 10;
end
if nargin<14
    fontsize_label = 12;
end
if nargin<13
    cbar_label = '';
end
if nargin<12
    cbar_limits = [0 1];
end
if nargin<11
    slice = 'axial';
end
if nargin<10
    edge_color = [0*ones(1,3), 0.05];
end
if nargin<9
    node_interest_markersize = 40;
end
if nargin<8
    node_interest_cmap = flipud(hot(M));
end
                                
if strcmpi(slice, 'axial')
    y_offset = 0.18;
    text_ylocation = 85;
elseif strcmpi(slice, 'sagittal_left') || strcmpi(slice, 'sagittal_right')
    y_offset = 0.06;
    text_ylocation = 100;
elseif strcmpi(slice, 'coronal')
    y_offset = 0.10;
    text_ylocation = 95;
end
        
frac_ind = dsearchn(frac_vec', frac_interest');

fig = figure('Position', [20 200 length(frac_interest)*100 200]);
ax1 = axes(fig);
hold on;
for j=1:length(frac_interest)
    if size(connectome,3)>1
        connectome_to_plot = connectome(:,:,frac_ind(j));
    else
        connectome_to_plot = connectome;
    end
    ax2 = axes(fig, 'Position', [0.005+(j-1)/length(frac_interest) y_offset 0.9/length(frac_interest) 0.8]);
    ax2 = draw_internode_brainNetworks_fast(ax2, connectome_to_plot, thres, node_interest(:,frac_ind(j)), nodeLocations, ...
                                 markersize, node_interest_data(:,frac_ind(j)), node_interest_cmap, ...
                                 node_interest_markersize, edge_color, slice);
                             
%     ax2 = draw_brain_nodeHighlight(ax2, node_interest, nodeLocations, ...
%                                  markersize, node_interest_data(:,frac_ind(j)), node_interest_cmap, ...
%                                  node_interest_markersize, slice);
    text(ax2, 0, text_ylocation, sprintf('%2.0f%%', frac_interest(j)*100), 'fontsize', fontsize_label, 'horizontalalignment', 'center')
    set(findall(ax2, 'type', 'text'), 'visible', 'on')
    caxis(cbar_limits)
    if j==length(frac_interest)
        cbar = colorbar(ax2, 'southoutside');
        ylabel(cbar, cbar_label, 'fontsize', fontsize_label)
        set(cbar, 'ticklength', 0.02, 'Position', [1-2.1/length(frac_interest) 0.2 2/length(frac_interest) 0.05], 'FontSize', fontsize_axis)
    end
end
set(ax1, 'visible', 'off')

end
