function [obj_scat1, obj_scat2, obj_scat3, obj_scat4, cbar] = draw_scatterBrain_allViews(fig, ...
                                        nodeLocations, data, init_axes_loc, node_sizes, cmap, cbar_limits, cbar_label)
% draw_scatterBrain_allViews.m
%
% Draw a scatter plot of brain nodes with colors based on data for
% a particular view slice
%
% Inputs: fig           : figure handle
%         nodeLocations : 3D locations of the nodes [Nx3]
%         data          : data used to color the nodes [Nx1]
%         init_axes_loc : initial locations of left most axes corresponding
%                         to the axial view [1x2]
%         node_sizes    : sizes of nodes for axial, sagittal, and coronal views [1x3]
%         cmap          : colormap [Mx3]
%         cbar_limits   : limits of colorbar [1x2]
%         cbar_label    : label of colorbar 
% Outputs: obj_scat1, obj_scat2, obj_scat3, obj_scat4 : object handles of
%                                                       the four scatterplots
%                                                cbar : colorbar handle
%
% Original: James Pang, QIMR Berghofer, 2019

%%
if nargin<8
    cbar_label = '';
end
if nargin<7
    cbar_limits = [min(data)*0.99, max(data)*1.01];
end
if nargin<6
    cmap = parula;
end
if nargin<5
    node_sizes = [100 80 100];
end
if nargin<4
    init_axes_loc = [0.00, 0.35];
end

% ax1, object1: scatter plot in axial view
ax1 = axes(fig, 'Position', [init_axes_loc(1) init_axes_loc(2) 0.3 0.4]);
[ax1, obj_scat1] = draw_scatterBrain(ax1, nodeLocations, data, node_sizes(1), ...
                                       'axial');
set(ax1, 'colormap', cmap)
caxis(cbar_limits)
annotation('textbox', [ax1.Position(1)+0.02, ax1.Position(2)+ax1.Position(4)*0.9, 0.1, 0.1], 'string', 'L', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')
annotation('textbox', [ax1.Position(1)+ax1.Position(3)*0.59, ax1.Position(2)+ax1.Position(4)*0.9, 0.1, 0.1], 'string', 'R', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')

% ax2, object3: scatter plot in sagittal view (left hemisphere)
ax2 = axes(fig, 'Position', [init_axes_loc(1)+0.33 init_axes_loc(2)+0.17 0.18 0.3]);
[ax2, obj_scat2] = draw_scatterBrain(ax2, nodeLocations, data, node_sizes(2), ...
                                       'sagittal_left');
set(ax2, 'colormap', cmap)                                   
caxis(cbar_limits)
annotation('textbox', [ax2.Position(1)*0.92, ax2.Position(2)+ax2.Position(4)*0.6, 0.1, 0.1], 'string', 'L', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')

% ax3, object3: scatter plot in sagittal view (right hemisphere)
ax3 = axes(fig, 'Position', [init_axes_loc(1)+0.33+0.11 init_axes_loc(2) 0.18 0.3]);
[ax3, obj_scat3] = draw_scatterBrain(ax3, nodeLocations, data, node_sizes(2), ...
                                       'sagittal_right');
set(ax3, 'colormap', cmap)                                   
caxis(cbar_limits)
annotation('textbox', [ax3.Position(1)+ax3.Position(3)*0.59, ax3.Position(2)+ax3.Position(4)*0.6, 0.1, 0.1], 'string', 'R', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')
cbar = colorbar(ax3,'southoutside');
ylabel(cbar, cbar_label, 'fontsize', 15, 'interpreter', 'latex')

set(cbar, 'Position', [init_axes_loc(1)+0.33 init_axes_loc(2)+0.02 0.3 0.02], 'FontSize', 12)

% ax4, object4: scatter plot in coronal view
ax4 = axes(fig, 'Position', [init_axes_loc(1)+0.68 init_axes_loc(2) 0.3 0.4]);
[ax4, obj_scat4] = draw_scatterBrain(ax4, nodeLocations, data, node_sizes(3), ...
                                       'coronal');
set(ax4, 'colormap', cmap)
caxis(cbar_limits)
annotation('textbox', [ax4.Position(1)+0.02, ax4.Position(2)+ax4.Position(4)*0.9, 0.1, 0.1], 'string', 'L', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')
annotation('textbox', [ax4.Position(1)+ax4.Position(3)*0.59, ax4.Position(2)+ax4.Position(4)*0.9, 0.1, 0.1], 'string', 'R', ...
   'fontsize', 10, 'LineStyle', 'none', 'horizontalalignment', 'center', ...
   'verticalalignment', 'middle', 'fontweight', 'b')

end

function [ax, obj] = draw_scatterBrain(ax, nodeLocations, data, markersize, slice)
% draw_scatterBrain.m
%
% Draw a scatter plot of brain nodes with colors based on data for
% a particular view slice
%
% Inputs: ax            : axis handle to plot on
%         nodeLocations : 3D locations of the nodes [Nx3]
%         data          : data used to color the nodes [Nx1]
%         markersize    : uniform size of the nodes (float)
%         slice         : view slice (string)
%                         'axial', 'sagittal_left', 'sagittal_right',
%                         'coronal'
% Outputs: ax           : redefine initial axis handle
%          obj          : object handle of the scatter plot
%
% Original: James Pang, QIMR Berghofer, 2019

%%
if nargin<5
    slice = 'axial';
end
if nargin<4
    markersize = 40;
end

if strcmpi(slice, 'axial')
    obj = scatter3(ax, nodeLocations(:,1), nodeLocations(:,2), nodeLocations(:,3), ...
                   markersize, data, 'filled');
elseif strcmpi(slice, 'sagittal_left')
    obj = scatter3(ax, -nodeLocations(:,2), nodeLocations(:,3), -nodeLocations(:,1), ...
                   markersize, data, 'filled');
elseif strcmpi(slice, 'sagittal_right')
    obj = scatter3(ax, nodeLocations(:,2), nodeLocations(:,3), nodeLocations(:,1), ...
                   markersize, data, 'filled');
elseif strcmpi(slice, 'coronal')
    obj = scatter3(ax, nodeLocations(:,1), nodeLocations(:,3), -nodeLocations(:,2), ...
                   markersize, data, 'filled');
end

view(ax, 2)
axis(ax, 'equal')
set(ax, 'visible', 'off')

end