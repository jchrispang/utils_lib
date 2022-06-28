function [fig, varargout] = draw_surface_bluewhitered(surface_to_plot, data_to_plot, hemisphere, medial_wall, with_medial)

if nargin<5
    with_medial = 0;
end

if nargin<4
    medial_wall = [];
end
    
if with_medial
    data_to_plot(medial_wall) = min(data_to_plot)*1.1;
    clims = [min(data_to_plot), max(data_to_plot)];
    if clims(2)<=0
        clims(2) = 0.01;
    end

    fig = figure('Position', [200 200 600 300]);
    ax1 = axes('Position', [0.03 0.1 0.45 0.8]);
    obj1 = patch(ax1, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot, ...
               'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
    if strcmpi(hemisphere, 'lh')
        view([-90 0]);
    elseif strcmpi(hemisphere, 'rh')
        view([90 0]);
    end
    caxis(clims)
    colormap(ax1,[0.5,0.5,0.5; bluewhitered])
    axis off
    axis image

    ax2 = axes('Position', [ax1.Position(1)+ax1.Position(3)*1.1 ax1.Position(2) ax1.Position(3) ax1.Position(4)]);
    obj2 = patch(ax2, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot, ...
               'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
    if strcmpi(hemisphere, 'lh')
        view([90 0]);
    elseif strcmpi(hemisphere, 'rh')
        view([-90 0]);
    end
    caxis(clims)
    colormap(ax2,[0.5,0.5,0.5; bluewhitered])
    axis off
    axis image
    
    varargout{1} = obj1;
    varargout{2} = obj2;
else
    fig = figure;
    set(fig, 'Position', get(fig, 'Position').*[1 1 0.6 0.6])
    ax = axes('Position', [0.01 0.01 0.98 0.98]);
    obj1 = patch(ax, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot, ...
               'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
    if strcmpi(hemisphere, 'lh')
        view([-90 0]);
    elseif strcmpi(hemisphere, 'rh')
        view([90 0]);
    end
    colormap(ax,[bluewhitered])
    axis off
    axis image
    
    varargout{1} = obj1;
end