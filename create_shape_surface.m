function surface_shape = create_shape_surface(shape, grid_step)
% create_shape_surface.m
%
% Create a surface of shape
%
% Inputs: shape         : type of shape (string)
%                        'square', 'diamond', 'triangle', 'circle'
%         grid_step : step size of uniform grid (float)
%
% Output: surface_shape : surface with vertices and faces (struct)
%
% Original: James Pang, Monash University, 2022

%%
if nargin<2
    grid_step = 0.02;
end

[x_grid, y_grid] = meshgrid(-1:grid_step:1, -1:grid_step:1);
x_grid = x_grid(:);
y_grid = y_grid(:);

radius = 0.95;

switch shape
    case 'square'
        x_shape = radius*[-1, -1, 1, 1]';
        y_shape = radius*[-1, 1, 1, -1]';
    case 'diamond'
        x_shape = [-radius, 0, radius, 0]';
        y_shape = [0, 1, 0, -1]';
    case 'triangle'
        h = 2*radius;
        height = sqrt(h^2 - h^2/4);
        x_shape = [-radius, 0, radius]';
        y_shape = [-1, -1+height, -1]';
    case 'circle'
        x_shape = radius*cos(linspace(0,2*pi,1000))';
        y_shape = radius*sin(linspace(0,2*pi,1000))';
end

in = inpolygon(x_grid, y_grid, x_shape, y_shape);

surface_shape = struct();
surface_shape.vertices = [x_grid(in), y_grid(in)];

surface_shape.faces = delaunay(surface_shape.vertices);

% figure;
% ax1 = gca;
% obj1 = patch(ax1, 'Vertices', surface_shape.vertices, 'Faces', surface_shape.faces, 'FaceVertexCData', ones(size(surface_shape.vertices,1),1), ...
%                'EdgeColor', 'k', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
% colormap(ax1, [1 1 1]);
% axis off
% axis image
