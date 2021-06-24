function avg_connectome = calc_avg_connectome(connectomes, threshold)
% calc_avg_connectome.m
%
% Calculate group-averaged connectome via consensus threhold
%
% Inputs: connectomes    : subject connectomes [NxNxM]
%                          N nodes and M subjects
%         threshold      : consensus threshold [float]
%                          values from 0 to 1
% Output: avg_connectome : group-averaged connectome [NxN]
%
% Original: James Pang, QIMR Berghofer, 2020

%%

num_subjects = size(connectomes,3);

subject_consistency = sum(connectomes>0, 3);                            % how many subjects have non-zero value per matrix element
connections_to_keep = (subject_consistency/num_subjects)>=threshold;    % which connections to keep according to threshold
avg_connectome = sum(connectomes,3)./subject_consistency;               % average disregarding the zeros
avg_connectome = avg_connectome.*connections_to_keep;                   % remove connections when number of subjects with non-zero value 
                                                                        % is less than the threshold
avg_connectome(isnan(avg_connectome)) = 0;                              % convert NaNs to zeros

