function [ax, obj] = draw_locationsBrain(ax, nodeLocations, nodeNames, data, markersize, fontsize, slice)
% draw_locationsBrain.m
%
% Draw a plot of brain nodes with their names overlayed for
% a particular view slice
%
% Inputs: ax            : axis handle to plot on
%         nodeLocations : 3D locations of the nodes [Nx3]
%         nodeNames     : anatomical names of the nodes [Nx1 string]
%         data          : data used to color the nodes [Nx1]
%         markersize    : uniform size of the nodes (float)
%         fontsize      : uniform size of overlayed node names (float)
%         slice         : view slice (string)
%                         'axial', 'sagittal_left', 'sagittal_right',
%                         'coronal'
% Outputs: ax           : redefine initial axis handle
%          obj          : object handle of the scatter plot
%
% Original: James Pang, QIMR Berghofer, 2019

%%
if nargin<7
    slice = 'axial';
end
if nargin<6
    fontsize = 8;
end
if nargin<5
    markersize = 40;
end

if strcmpi(slice, 'axial')
    x = nodeLocations(:,1); y = nodeLocations(:,2); z = nodeLocations(:,3);
    obj = scatter3(ax, x, y, z, markersize, data, 'filled');
    text(ax, x, y, z, nodeNames, 'fontsize', fontsize, 'interpreter', 'none')
elseif strcmpi(slice, 'sagittal_left')
    x = -nodeLocations(:,2); y = nodeLocations(:,3); z = -nodeLocations(:,1);
    obj = scatter3(ax, x, y, z, markersize, data, 'filled');
    text(ax, x, y, z, nodeNames, 'fontsize', fontsize, 'interpreter', 'none')
elseif strcmpi(slice, 'sagittal_right')
    x = nodeLocations(:,2); y = nodeLocations(:,3); z = nodeLocations(:,1);
    obj = scatter3(ax, x, y, z, markersize, data, 'filled');
    text(ax, x, y, z, nodeNames, 'fontsize', fontsize, 'interpreter', 'none')
elseif strcmpi(slice, 'coronal')
    x = nodeLocations(:,1); y = nodeLocations(:,3); z = -nodeLocations(:,2);
    obj = scatter3(ax, x, y, z, markersize, data, 'filled');
    text(ax, x, y, z, nodeNames, 'fontsize', fontsize, 'interpreter', 'none')
end

view(ax, 2)
axis(ax, 'equal')
set(ax, 'visible', 'off')
