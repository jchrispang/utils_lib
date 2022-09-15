function FC = calc_FC(data, do_normalize)
% calc_FC.m
%
% Calculate FC
%
% Inputs: data         : fMRI data [TxN]
%                        T = length of time
%                        N = number of points
%         do_normalize : normalize data or not (boolean) 
%
% Output: FC
%
% Original: James Pang, Monash University, 2021

%%

T = size(data,1);

if do_normalize
    data_normalized = detrend(data, 'constant');
    data_normalized = data_normalized./repmat(std(data_normalized),T,1);
    data_normalized(isnan(data_normalized)) = 0;
    c = data_normalized'*data_normalized;
else
    c = data'*data;
end

c = c/T;
c(isnan(c)) = 0;
FC = c;


