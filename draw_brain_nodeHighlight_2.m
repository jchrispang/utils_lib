function ax = draw_brain_nodeHighlight_2(ax, node_interest, nodeLocations, ...
                                 markersize, node_data, node_cmap, ...
                                 node_interest_markersize, slice)
% draw_brain_nodeHighlight.m
%
% Draw a scatter plot of brain nodes and node_interest
% in a particular view slice
%
% Inputs: ax                       : axis handle to plot on
%         node_interest            : nodes to highlight [1xM]
%         nodeLocations            : 3D locations of the nodes [Nx3]
%         markersize               : uniform size of the nodes (float)
%         node_data                : properties of node [1xM]
%         node_cmap                : colormap of node_data [Mx3]
%         node_interest_markersize : markersize of node_interest [float]
%         slice                    : view slice (string)
%                                    'axial', 'sagittal_left', 'sagittal_right',
%                                    'coronal'
% Outputs: ax                      : redefine initial axis handle
%
% Original: James Pang, QIMR Berghofer, 2020

%%
if strcmpi(slice, 'axial')
    nodeLocations = cat(2, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3));
elseif strcmpi(slice, 'sagittal_left')
    nodeLocations = cat(2, -nodeLocations(:,2), nodeLocations(:,3), -nodeLocations(:,1));
elseif strcmpi(slice, 'sagittal_right')
    nodeLocations = cat(2, nodeLocations(:,2), nodeLocations(:,3), nodeLocations(:,1));
elseif strcmpi(slice, 'coronal')
    nodeLocations = cat(2, nodeLocations(:,1), nodeLocations(:,3), -nodeLocations(:,2));
end

N = size(nodeLocations,1);
noninterest = setdiff(1:N, node_interest);

% scatterBrain_all(ax, nodeLocations(noninterest,:), markersize);
scatter3(ax, nodeLocations(noninterest,1), nodeLocations(noninterest,2), nodeLocations(noninterest,3), ...
                   markersize, node_data(noninterest), 'filled', 'markeredgecolor', 'k');
hold on;
scatter3(ax, nodeLocations(node_interest,1), nodeLocations(node_interest,2), nodeLocations(node_interest,3), ...
                   node_interest_markersize, node_data(node_interest), 'filled', 'markeredgecolor', 'k');
hold off;
set(ax, 'colormap', node_cmap)
view(ax, 2)
axis(ax, 'equal')
set(ax, 'visible', 'off')

end

function obj = scatterBrain_all(ax, nodeLocations, markersize)

obj = scatter3(ax, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3), ...
                markersize, 'markeredgecolor', 0.3*[1 1 1], 'markerfacecolor', 'none', ...
                'markeredgealpha', 0.3);
            
end

