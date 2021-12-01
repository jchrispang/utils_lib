function dice_matrix = calc_dice_matrix(parc_1, parc_2)
% calc_dice_matrix.m
%
% Calculate dice coefficient of every pair of parcels
%
% Inputs: parc_1      : volume (3d array) or surface (1d array) of parcellation 1
%         parc_2      : volume (3d array) or surface (1d array) of parcellation 2
%
% Output: dice_matrix : matrix of dice coefficients
%
% Original: James Pang, Monash University, 2021

%%

parcels_1 = unique(parc_1(parc_1>0));
parcels_2 = unique(parc_2(parc_2>0));
num_parcels_1 = length(parcels_1);
num_parcels_2 = length(parcels_2);

dice_matrix = zeros(num_parcels_1, num_parcels_2);

for ii = 1:num_parcels_1
    parc_1_temp = (parc_1==parcels_1(ii));

    for jj = 1:num_parcels_2
        parc_2_temp = (parc_2==parcels_2(jj));

        dice_matrix(ii,jj) = dice(parc_1_temp, parc_2_temp);
    end
end