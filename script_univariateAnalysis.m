clc;
clear all;
close all;

% load table
load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev04.mat');

%%
tableMulticentric(tableMulticentric.centerID == 2, :) = [];

%% Bern
% tableBern = tableMulticentric(tableMulticentric.centerID == 1, :);

figure;
subplot(2, 1, 1)
scatter(tableMulticentric.amplitude, tableMulticentric.relativeImprovement);
[rho_imp, p_imp] = corr(tableMulticentric.amplitude, tableMulticentric.relativeImprovement);
xlabel('Amplitude');
ylabel('Relative Improvement')
title(['Correlation (spearman): \rho = ', num2str(rho_imp), 'p = ', num2str(p_imp)]);

subplot(2, 1, 2)
scatter(tableMulticentric.amplitude, tableMulticentric.efficiency);
[rho_eff, p_eff] = corr(tableMulticentric.amplitude, tableMulticentric.efficiency);
xlabel('Amplitude');
ylabel('Efficiency');
title(['Correlation (spearman): \rho = ', num2str(rho_eff), 'p = ', num2str(p_eff)]);

%% Cologne
% tableCologne = tableMulticentric(centerID == 2);
