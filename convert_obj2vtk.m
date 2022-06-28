function convert_obj2vtk(obj_file, vtk_file)

% obj_file = '315.obj';
% vtk_file = '315.vtk';

if nargin<2
    [filepath, name, ext] = fileparts(obj_file);
    vtk_file = [name, '.vtk'];
end

temp = readObj(obj_file);
vertices = temp.v;
faces = temp.f.v;
num_vertices = size(vertices,1);
num_faces = size(faces,1);

f = fopen(vtk_file, 'w');
fwrite(f, sprintf('# vtk DataFile Version 2.0\n'));
fwrite(f, sprintf([vtk_file, '\n']));
fwrite(f, sprintf('ASCII\n'));
fwrite(f, sprintf('DATASET POLYDATA\n'));
fwrite(f, sprintf('POINTS %i float\n', num_vertices));
for ii = 1:num_vertices
    fwrite(f, sprintf('%.2f %.2f %.2f\n', vertices(ii,1), vertices(ii,2), vertices(ii,3)));
%     fwrite(f, '\n');
end
% fwrite(f, '\n');
fwrite(f, sprintf('POLYGONS %i %i\n', num_faces, 4*num_faces));
for ii = 1:num_faces
    fwrite(f, sprintf('%i %i %i %i\n', 3, faces(ii,1)-1, faces(ii,2)-1, faces(ii,3)-1));
%     fwrite(f, '\n');
end
fclose(f);
