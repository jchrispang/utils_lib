#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Utility functions in python

@author: James Pang, Monash University, 2022
"""

def calc_dice_matrix(parc_1, parc_2):
    """Calculate dice coefficient of every pair of parcels
    
    Parameters
    ----------
    parc_1 : array
        Volume (3d array) or surface (1d array) of parcellation 1
    parc_2 : array
        Volume (3d array) or surface (1d array) of parcellation 2

    Returns
    ------
    dice_matrix : array
        Matrix of dice coefficients
    """
    
    # Import libraries
    import numpy as np
    from scipy.spatial import distance

    parcels_1 = np.unique(parc_1[parc_1>0])
    parcels_2 = np.unique(parc_2[parc_2>0])
    num_parcels_1 = len(parcels_1)
    num_parcels_2 = len(parcels_2)
    
    dice_matrix = np.zeros((num_parcels_1, num_parcels_2))
    
    for ii in np.arange(0,num_parcels_1):
        parc_1_temp = (parc_1==parcels_1[ii])
        
        for jj in np.arange(0,num_parcels_2):
            parc_2_temp = (parc_2==parcels_2[jj])
            
            dice_matrix[ii,jj] = 1 - distance.dice(parc_1_temp, parc_2_temp)

    return dice_matrix

def calc_dice_mean(parc_1, parc_2):
    """Calculate mean dice coefficient across every pair of parcels
    
    Parameters
    ----------
    parc_1 : array
        Volume (3d array) or surface (1d array) of parcellation 1
    parc_2 : array
        Volume (3d array) or surface (1d array) of parcellation 2

    Returns
    ------
    dice_mean : float
        Mean dice coefficient
    """
    
    # Import libraries
    import numpy as np
    from scipy.spatial import distance

    parcels_1 = np.unique(parc_1[parc_1>0])
    parcels_2 = np.unique(parc_2[parc_2>0])
    num_parcels_1 = len(parcels_1)
    num_parcels_2 = len(parcels_2)
    
    dice_matrix = np.zeros((num_parcels_1, num_parcels_2))
    
    for ii in np.arange(0,num_parcels_1):
        parc_1_temp = (parc_1==parcels_1[ii])
        
        for jj in np.arange(0,num_parcels_2):
            parc_2_temp = (parc_2==parcels_2[jj])
            
            dice_matrix[ii,jj] = 1 - distance.dice(parc_1_temp, parc_2_temp)
    
#    dice_mean = np.sum(dice_matrix)/np.sqrt(num_parcels_1*num_parcels_2)
    
    if num_parcels_1 != 1 and num_parcels_2 !=1:
        dice_mean_temp_1 = np.sum(np.diag(dice_matrix))/np.max([num_parcels_1, num_parcels_2])   
        dice_mean_temp_2 = np.sum(np.diag(np.fliplr(dice_matrix)))/np.max([num_parcels_1, num_parcels_2])   

        if dice_mean_temp_1 >= dice_mean_temp_2:
            dice_mean = dice_mean_temp_1
        else:
            dice_mean = dice_mean_temp_2
    else:
        dice_mean = np.max(dice_matrix)/np.max([num_parcels_1, num_parcels_2])   
            
    return dice_mean

def convert_posneg_label(array):
    """Convert array with positive and negative values to discrete labels.
    1 for positive (inclusive of zero) and 2 for negative.
    
    Parameters
    ----------
    array : array
        Volume (3d array) or surface (1d array)

    Returns
    ------
    array_label : array
        Relabelled input array
    """
    
    # Import libraries
    import numpy as np
    
    array_label = np.copy(array)
    array_label[array>=0] = 1
    array_label[array<0] = 2   

    return array_label
