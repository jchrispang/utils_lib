function [fig, varargout] = draw_surface_bluewhitered_gallery_dull(surface_to_plot, data_to_plot, hemisphere, medial_wall, with_medial)

if nargin<5
    with_medial = 0;
end

if nargin<4
    medial_wall = [];
end

num_modes = size(data_to_plot,2);
       
if with_medial
    factor_x_small = 1.02;
    factor_x_big = 2.1;
    init_x = 0.005;
    init_y = 0.01;
    length_x = (1-2*init_x)/(factor_x_small + factor_x_big*(num_modes-1) + 1);
    length_y = (1-2*init_y);
    fig = figure('Position', [200 200 num_modes*400 150]);
    for mode=1:num_modes
        data_to_plot(medial_wall,mode) = min(data_to_plot(:,mode))*1.1;
        clims = [min(data_to_plot(:,mode)), max(data_to_plot(:,mode))];
        if clims(2)<=0
            clims(2) = 0.01;
        end
    
        ax1 = axes('Position', [init_x+factor_x_big*length_x*(mode-1) init_y length_x length_y]);
        obj1 = patch(ax1, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot(:,mode), ...
                   'EdgeColor', 'none', 'FaceColor', 'interp');
        if strcmpi(hemisphere, 'lh')
            view([-90 0]);
        elseif strcmpi(hemisphere, 'rh')
            view([90 0]);
        end
        caxis(clims)
        camlight('headlight')
        material dull
        colormap(ax1,[0.5,0.5,0.5; bluewhitered])
        axis off
        axis image
        
        ax2 = axes('Position', [init_x+factor_x_small*length_x+factor_x_big*length_x*(mode-1) init_y length_x length_y]);
        obj2 = patch(ax2, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot(:,mode), ...
                   'EdgeColor', 'none', 'FaceColor', 'interp');
        if strcmpi(hemisphere, 'lh')
            view([90 0]);
        elseif strcmpi(hemisphere, 'rh')
            view([-90 0]);
        end
        caxis(clims)
        camlight('headlight')
        material dull
        colormap(ax2,[0.5,0.5,0.5; bluewhitered])
        axis off
        axis image
    end
    
    
%     fig = figure('Position', [200 200 600 300]);
%     ax1 = axes('Position', [0.03 0.1 0.45 0.8]);
%     obj1 = patch(ax1, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot, ...
%                'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
%     if strcmpi(hemisphere, 'lh')
%         view([-90 0]);
%     elseif strcmpi(hemisphere, 'rh')
%         view([90 0]);
%     end
%     caxis(clims)
%     colormap(ax1,[0.5,0.5,0.5; bluewhitered])
%     axis off
%     axis image
% 
%     ax2 = axes('Position', [ax1.Position(1)+ax1.Position(3)*1.1 ax1.Position(2) ax1.Position(3) ax1.Position(4)]);
%     obj2 = patch(ax2, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot, ...
%                'EdgeColor', 'none', 'FaceColor', 'interp', 'FaceLighting', 'gouraud');
%     if strcmpi(hemisphere, 'lh')
%         view([90 0]);
%     elseif strcmpi(hemisphere, 'rh')
%         view([-90 0]);
%     end
%     caxis(clims)
%     colormap(ax2,[0.5,0.5,0.5; bluewhitered])
%     axis off
%     axis image
%     
%     varargout{1} = obj1;
%     varargout{2} = obj2;
else
    factor_x = 1.05;
    init_x = 0.01;
    init_y = 0.01;
    length_x = (1-2*init_x)/(factor_x*(num_modes-1) + 1);
    length_y = (1-2*init_y);
    fig = figure('Position', [200 200 num_modes*200 150]);
    for mode=1:num_modes
        ax = axes('Position', [init_x+factor_x*length_x*(mode-1) init_y length_x length_y]);
        obj1 = patch(ax, 'Vertices', surface_to_plot.vertices, 'Faces', surface_to_plot.faces, 'FaceVertexCData', data_to_plot(:,mode), ...
                   'EdgeColor', 'none', 'FaceColor', 'interp');
        if strcmpi(hemisphere, 'lh')
            view([-90 0]);
        elseif strcmpi(hemisphere, 'rh')
            view([90 0]);
        end
        camlight('headlight')
        material dull
        colormap(ax,[bluewhitered])
        axis off
        axis image
    end
end