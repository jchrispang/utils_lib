function [num_nodes, LH, RH] = extract_hemisphere_indices(parcellation)
% extract_hemisphere_indices.m
%
% Extract the indices of the left and right hemispheres
%
% Input: parcellation   : parcellation name (string)
%
% Outputs: num_nodes    : number of nodes (integer)
%          LH           : indices of the left hemisphere (vector)
%          RH           : indices of the right hemisphere (vector)
%
% Original: James Pang, QIMR Berghofer, 2020

%%

% number of nodes
if strcmpi(parcellation, 'Desikan_Killiany_84')
    num_nodes = str2double(parcellation(end-1:end));
else
    num_nodes = str2double(parcellation(end-2:end));
end

% left and right hemisphere indices
if strcmpi(parcellation, 'Gordon_333')
    LH = 1:161;
    RH = 162:333;
elseif strcmpi(parcellation, 'Gordon333_TianS1_349')
    LH = 1:169;
    RH = 170:349;
elseif strcmpi(parcellation, 'Gordon333_TianS2_365')
    LH = 1:177;
    RH = 178:365;
elseif strcmpi(parcellation, 'Gordon333_TianS3_383')
    LH = 1:186;
    RH = 187:383;
elseif strcmpi(parcellation, 'Gordon333_TianS4_387')
    LH = 1:188;
    RH = 189:387;    
elseif strcmpi(parcellation, 'Power_264')
    % NOTE: Power atlas is not hemisphere specific
    LH = 1:num_nodes;
    RH = 1:num_nodes;
elseif strcmpi(parcellation, 'AAL_116') || strcmpi(parcellation, 'AAL2_120') || strcmpi(parcellation, 'Brainnetome_246') || strcmpi(parcellation, 'Aicha_384')
    LH = 1:2:num_nodes;
    RH = 2:2:num_nodes;
elseif strcmpi(parcellation, 'AAL3_170')
    % NOTE: Last 2 nodes are not hemisphere specific
    LH = [1:2:168, 169:170];
    RH = [2:2:168, 169:170];
elseif strcmpi(parcellation, 'QIMR_513')
    LH = [1:floor(num_nodes/2), 513];
    RH = (floor(num_nodes/2) + 1):(num_nodes-1);
elseif strcmpi(parcellation, 'Schaefer_Buckner_448')
    LH = [1:200, 401:407, 415:431];
    RH = [201:400, 408:414, 432:448];
elseif strcmpi(parcellation, 'Schaefer_HarvardOxford_414')
    LH = [1:200, 401:407];
    RH = [201:400, 408:414];
else
    LH = 1:floor(num_nodes/2);
    RH = (floor(num_nodes/2) + 1):num_nodes;
end
