function ax = draw_internode_brainNetworks_fast(ax, connectome, thres, node_interest, nodeLocations, ...
                                 markersize, node_interest_data, node_interest_cmap, ...
                                 node_interest_markersize, edge_color, slice)
% draw_internode_brainNetworks_fast.m
%
% Draw a scatter plot of brain nodes and connections between node_interest
% in a particular view slice
%
% Inputs: ax                       : axis handle to plot on
%         connectome               : weighted connectivity matrix [NxN]
%         thres                    : fraction of top weights to show in (float)
%                                    0 = no weights preserved
%                                    1 = all weights preserved
%         node_interest            : nodes to highlight [1xM]
%         nodeLocations            : 3D locations of the nodes [Nx3]
%         markersize               : uniform size of the nodes (float)
%         node_interest_data       : properties of node_interest [1xM]
%         node_interest_cmap       : colormap of node_interest_data [Mx3]
%         node_interest_markersize : markersize of node_interest [float]
%         edge_color               : color of edges (string) or [1x3]
%         slice                    : view slice (string)
%                                    'axial', 'sagittal_left', 'sagittal_right',
%                                    'coronal'
% Outputs: ax                      : redefine initial axis handle
%
% Original: James Pang, QIMR Berghofer, 2021

%%

N = size(connectome,2);
noninterest = setdiff(1:N, node_interest);

connectome_hubs = zeros(N,N);
connectome_hubs(node_interest,node_interest) = 1;
connectome = connectome.*connectome_hubs;
connectome = threshold_proportional(connectome, thres);           % threshold connectome

[edge_X, edge_Y, edge_Z] = adjacency_plot_und(connectome, nodeLocations);  % get all the edges

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

if length(noninterest)<N
    scatterBrain_all(ax, nodeLocations(noninterest,:), markersize);
end

hold on;
plot3(edges(:,1), edges(:,2), edges(:,3), 'color', edge_color, 'linewidth', 0.1);
scatter3(ax, nodeLocations(node_interest,1), nodeLocations(node_interest,2), nodeLocations(node_interest,3), ...
                   node_interest_markersize, node_interest_data, 'filled', 'markeredgecolor', 'k');
hold off;
       
set(ax, 'colormap', node_interest_cmap)
view(ax, 2)
axis(ax, 'equal')
set(ax, 'visible', 'off')

end

function obj = scatterBrain_all(ax, nodeLocations, markersize)

obj = scatter3(ax, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3), ...
                markersize, 'markeredgecolor', 0.3*[1 1 1], 'markerfacecolor', 'none', ...
                'markeredgealpha', 0.3);
            
end

