function [rand_vertices_ind_L, rand_vertices_ind_R] = create_spin_rotations(vertices_L, vertices_R, num_rotations)
% create_spin_rotations.m
%
% Create random spin rotations of left and right sphere surfaces
%
% Inputs: vertices_L       : vertices of left hemiphere sphere surface [N x 3]
%                            N = number of vertices
%         vertices_R       : vertices of right hemiphere sphere surface [N x 3]
%         num_rotations    : number of rotations (integer)
%
% Outputs: rand_vertices_ind_L : indices of random spin rotations of left hemisphere vertices [N x num_rotations]
%          rand_vertices_ind_R : indices of random spin rotations of right hemisphere vertices [N x num_rotations]
%
% Original: James Pang, Monash University, 2021
%
% Adopted from
% https://github.com/spin-test/spin-test/blob/master/scripts/SpinPermuFS.m
% and the Brainspace toolbox
% (https://brainspace.readthedocs.io/en/latest/index.html)

%%
if size(vertices_L,2)~=3
   vertices_L = vertices_L';
end
if size(vertices_R,2)~=3
   vertices_R = vertices_R';
end

tree_L = KDTreeSearcher(vertices_L);
tree_R = KDTreeSearcher(vertices_R);

rand_vertices_ind_L = zeros(size(vertices_L,1), num_rotations);
rand_vertices_ind_R = zeros(size(vertices_R,1), num_rotations);

for rot_ind = 1:num_rotations
    
    % uniform sampling procedure
    I1 = diag([-1 1 1]);
    A = normrnd(0,1,3,3);
    [rotation_L, temp] = qr(A);
    rotation_L = rotation_L * diag(sign(diag(temp)));
    if(det(rotation_L)<0)
        rotation_L(:,1) = -rotation_L(:,1);
    end

    %reflect across the Y-Z plane for right hemisphere
    rotation_R = I1 * rotation_L * I1;

    rotated_vertices_L = vertices_L*rotation_L;
    rotated_vertices_R = vertices_R*rotation_R;

    rand_vertices_ind_L(:,rot_ind) = knnsearch(tree_L, rotated_vertices_L);
    rand_vertices_ind_R(:,rot_ind) = knnsearch(tree_R, rotated_vertices_R);
end

