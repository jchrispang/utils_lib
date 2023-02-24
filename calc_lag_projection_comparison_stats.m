function [r_peak_lags, KS, r_mean_lags] = calc_lag_projection_comparison_stats(data_1, data_2)

% data_1 = data_empirical.peak_lags;
% data_2 = data_model_wave.peak_lags;

%% correlation of upper triangle
triu_ind = calc_triu_ind(data_1);

% figure;
% plot(data_1(triu_ind), data_2(triu_ind), '.')
r_peak_lags = corr(data_1(triu_ind), data_2(triu_ind));

%% KS statistic of upper triangle distributions
% 
% figure;
% hold on;
% histogram(zscore(data_1(triu_ind)), 'facecolor', 'k', 'normalization', 'probability')
% histogram(zscore(data_2(triu_ind)), 'facecolor', 'r', 'normalization', 'probability')
% hold off;

% [~,~,KS] = kstest2(data_1(triu_ind),data_2(triu_ind));
[~,~,KS] = kstest2(zscore(data_1(triu_ind)), zscore(data_2(triu_ind)));

%% correlation of mean lags

% figure;
% plot(nanmean(data_1), nanmean(data_2), '.')
r_mean_lags = corr(nanmean(data_1)', nanmean(data_2)');