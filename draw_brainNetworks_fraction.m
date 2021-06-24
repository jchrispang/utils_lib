function ax = draw_brainNetworks_fraction(ax, connectome, nodeLocations, ...
                                       frac, markersize, node_data, node_cmap, ...
                                       edge_color, edge_width, slice)
% draw_brainNetworks_fraction.m
%
% Draw a scatter plot of brain network showing a fraction of top connections
%
% Inputs: ax                : axis handle to plot on
%         connectome        : weighted connectivity matrix [NxN]
%         nodeLocations     : 3D locations of the nodes [Nx3]
%         frac              : fraction of top weights to show in (float)
%                             0 = no weights preserved
%                             1 = all weights preserved
%         markersize        : uniform size of the nodes (float)
%         node_data         : node_data [Mx3]
%         node_cmap         : colormap of node_data [Mx3]
%         edge_color        : color of edges (string) or [1x3]
%         edge_width        : linewidth of edge [float]
%         slice             : view slice (string)
%                             'axial', 'sagittal_left', 'sagittal_right',
%                             'coronal'
% Outputs: ax               : redefine initial axis handle
%
% Original: James Pang, QIMR Berghofer, 2020

%%

if nargin < 10
    slice = 'axial';
end
if nargin<9
    edge_width = 1;
end
if nargin<8
    edge_color = [0 0.5 0 0.1];
end
if nargin<7
    node_cmap = [1,0,0];
end
if nargin<6
    node_data = ones(size(connectome,2),1);
end
if nargin<5
    markersize = 30;
end
if nargin<4
    frac = 0.1;
end


connectome_thres = threshold_proportional(connectome, frac);           % threshold connectome
[edge_X, edge_Y, edge_Z] = adjacency_plot_und(connectome_thres, nodeLocations);  % get all the edges

if strcmpi(slice, 'axial')
    nodeLocations = cat(2, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3));
    edges = cat(2, edge_X, edge_Y, edge_Z);
elseif strcmpi(slice, 'sagittal_left')
    nodeLocations = cat(2, -nodeLocations(:,2), nodeLocations(:,3), -nodeLocations(:,1));
    edges = cat(2, -edge_Y, edge_Z, -edge_X);
elseif strcmpi(slice, 'sagittal_right')
    nodeLocations = cat(2, nodeLocations(:,2), nodeLocations(:,3), nodeLocations(:,1));
    edges = cat(2, edge_Y, edge_Z, edge_X);
elseif strcmpi(slice, 'coronal')
    nodeLocations = cat(2, nodeLocations(:,1), nodeLocations(:,3), -nodeLocations(:,2));
    edges = cat(2, edge_X, edge_Z, -edge_Y);
end

hold on;
plot3(edges(:,1), edges(:,2), edges(:,3), 'color', edge_color, 'linewidth', edge_width);
scatter3(ax, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3), ...
             markersize, node_data, 'filled', 'markeredgecolor', 'k');
hold off;
        
set(ax, 'colormap', node_cmap)
view(ax, 2)
axis(ax, 'equal')
set(ax, 'visible', 'off')

end
