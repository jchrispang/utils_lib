function [centroids, volumes] = get_centroid_and_volume(parcellation_file)


hdr = spm_vol(parcellation_file);
parcellation_vol = spm_read_vols(hdr);

num_nodes = max(parcellation_vol(:));

centroids = zeros(num_nodes, 3);
volumes = zeros(num_nodes,1);
for node = 1:num_nodes
    ind = find(parcellation_vol==node);
    [x, y, z] = ind2sub(hdr.dim, ind);
    
    % finding centroid and volume size in voxel coordinates
    centroid_voxel = [mean(x), mean(y), mean(z)];
    volume_voxel = [length(x), length(y), length(z)];
    
    % converting to image space in mm
    centroid_image = hdr.mat*[centroid_voxel, 1]';
    volume_image = hdr.mat*[volume_voxel, 0]';
    
    % saving to variables
    centroids(node, :) = centroid_image(1:3);
    volumes(node) = sum(abs(volume_image(1:3)));
end
