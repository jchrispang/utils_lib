function [ax, obj] = draw_eigenvector_to_surface(ax, vertex, face, data, slice)
% draw_eigenvector_to_surface.m
%
% Draw patch of projection of eigencector on surface on a particular view slice
%
% Inputs: ax     : axis handle to plot on
%         vertex : surface vertex data vertex data of surface [Vx3]
%                  V = number of vertices
%         face   : surface face data [Fx1]
%                  F = number of faces
%         data   : eigenvector data [Vx1]
%         slice  : view slice (string)
%                  'axial_top', 'axial_bottom', 'sagittal_left', 'sagittal_right',
%                  'coronal'
% Outputs: ax    : redefine initial axis handle
%          obj   : object handle of the patch
%
% Original: James Pang, Monash University, 2021

%%
if nargin<5
    slice = 'axial_top';
end

obj = patch(ax, 'Vertices', vertex, 'Faces', face, 'FaceVertexCData', data, 'EdgeColor', 'none', 'FaceColor', 'interp');

if strcmpi(slice, 'axial_top')
    view([0 180]);
elseif strcmpi(slice, 'axial_bottom')
    view(ax, [0 0]);
elseif strcmpi(slice, 'sagittal_left')
    rotate(obj, [1 0 0], 90);
    view(ax, [270 0]);
elseif strcmpi(slice, 'sagittal_right')
    rotate(obj, [1 0 0], 90)
    view(ax, [90 0]);
elseif strcmpi(slice, 'coronal')
    view(ax, [0 90]);
end

set(ax, 'visible', 'off')
