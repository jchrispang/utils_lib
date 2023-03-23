function [parc_list_by_mask, parc_list_by_structure] = get_subcortical_parc_list()

% only for more than one parcel in each hemisphere

%% by mask type
% Tian
parc_list_by_mask.Tian.HIP = [4, 8, 10];
parc_list_by_mask.Tian.AMY = [4];
parc_list_by_mask.Tian.THA = [8, 14, 16];
parc_list_by_mask.Tian.NAc = [4];
parc_list_by_mask.Tian.GP = [4];
parc_list_by_mask.Tian.PUT = [4, 8];
parc_list_by_mask.Tian.CAU = [4, 8];

% Cartmell
parc_list_by_mask.Cartmell.NAc = [4];

% Julich
parc_list_by_mask.Julich.HIP = [6];
parc_list_by_mask.Julich.AMY = [6];

% Morel
parc_list_by_mask.Morel.THA = [61];

% Oxford
parc_list_by_mask.Oxford.THA = [13];

% PD
parc_list_by_mask.PD.GP = [4];

%% by structure
% HIP
parc_list_by_structure.HIP.Tian = [4, 8, 10];
parc_list_by_structure.HIP.Julich = [6];

% AMY
parc_list_by_structure.AMY.Tian = [4];
parc_list_by_structure.AMY.Julich = [6];

% THA
parc_list_by_structure.THA.Tian = [8, 14, 16];
parc_list_by_structure.THA.Morel = [61];
parc_list_by_structure.THA.Oxford = [13];

% NAc
parc_list_by_structure.NAc.Tian = [4];
parc_list_by_structure.NAc.Cartmell = [4];

% GP
parc_list_by_structure.GP.Tian = [4];
parc_list_by_structure.GP.PD = [4];

% PUT
parc_list_by_structure.PUT.Tian = [4, 8];

% CAU
parc_list_by_structure.CAU.Tian = [4, 8];



