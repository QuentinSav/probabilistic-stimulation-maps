clc
clear all
close all

%% Bias-variance trade-off figure

f = @(x) - x.^2 + 5*x + 10 + 10*rand(length(x), 1);
x = 14*rand(20, 1)- 7;
y = f(x);

obj_underfit = fit(x,y,'poly1');
obj_nicefit = fit(x,y,'poly2');
obj_overfit = fit(x,y,'poly9');

figure;
subplot(1, 3, 1);
plot(obj_underfit, x, y);
legend off;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis([-5 7 -40 30]);

subplot(1, 3, 2);
plot(obj_nicefit, x, y);
legend off;
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis([-5 7 -40 30]);

subplot(1, 3, 3);
plot(obj_overfit, x, y);
legend({'data', 'model'});
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axis([-5 7 -40 30]);

%% Result figure 1: Relative improvement vs efficiency
%  Note: In util_getValidPartition.m, the CV partition method should be
%        hold-out 10% with setting the seed befor cvpartition() in order to
%        have the same partition for efficiency and rel. improvement

clc
close all

load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev05.mat');

psm_rImp = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm_rImp.compute();

tableMulticentric = renamevars(tableMulticentric, 'clinicalScore', 'relativeImprovement');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');

psm_eff = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm_eff.compute();

fun_evaluate_Nguyen2019_eff_vs_relImp(psm_rImp, 'relImp');
fun_evaluate_Nguyen2019_eff_vs_relImp(psm_eff, 'eff');

%% Results figure 2

% load table
load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev04.mat');

% Multicenter
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

% Bern
tableBern = tableMulticentric(tableMulticentric.centerID == 1, :);

figure;
subplot(2, 1, 1)
scatter(tableBern.amplitude, tableBern.relativeImprovement);
[rho_imp, p_imp] = corr(tableBern.amplitude, tableBern.relativeImprovement);
xlabel('Amplitude');
ylabel('Relative Improvement')
title(['Correlation (spearman): \rho = ', num2str(rho_imp), 'p = ', num2str(p_imp)]);

subplot(2, 1, 2)
scatter(tableBern.amplitude, tableBern.efficiency);
[rho_eff, p_eff] = corr(tableBern.amplitude, tableBern.efficiency);
xlabel('Amplitude');
ylabel('Efficiency');
title(['Correlation (spearman): \rho = ', num2str(rho_eff), 'p = ', num2str(p_eff)]);

% Cologne
tableCologne = tableMulticentric(tableMulticentric.centerID == 1, :);

figure;
subplot(2, 1, 1)
scatter(tableCologne.amplitude, tableCologne.relativeImprovement);
[rho_imp, p_imp] = corr(tableCologne.amplitude, tableCologne.relativeImprovement);
xlabel('Amplitude');
ylabel('Relative Improvement')
title(['Correlation (spearman): \rho = ', num2str(rho_imp), 'p = ', num2str(p_imp)]);

subplot(2, 1, 2)
scatter(tableCologne.amplitude, tableCologne.efficiency);
[rho_eff, p_eff] = corr(tableCologne.amplitude, tableCologne.efficiency);
xlabel('Amplitude');
ylabel('Efficiency');
title(['Correlation (spearman): \rho = ', num2str(rho_eff), 'p = ', num2str(p_eff)]);


%% Result figure 3-4-5-6:

clc
close all

% Generate the maps

load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev05.mat');

psm_Nguyen2019 = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm_Dembek2019 = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Dembek2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm_Reich2019 = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Reich2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm_Nowacki2022 = PSM(tableMulticentric(:, :), ...
    'algorithm', 'Nowacki2022', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

%% Figure 3

psm_Nguyen2019.compute();
R2_Nguyen2019 = psm_Nguyen2019.evaluate('overlap_ratio');
CoM_Nguyen2019 = psm_Nguyen2019.results.CoM;
psm_Nguyen2019 = [];

psm_Dembek2019.compute();
R2_Dembek2019 = psm_Dembek2019.evaluate('overlap_ratio');
CoM_Dembek2019 = psm_Dembek2019.results.CoM;
psm_Dembek2019 = [];

psm_Reich2019.compute();
R2_Reich2019 = psm_Reich2019.evaluate('overlap_ratio');
CoM_Reich2019 = psm_Reich2019.results.CoM;
psm_Reich2019 = [];

psm_Nowacki2022.compute();
R2_Nowacki2022 = psm_Nowacki2019.evaluate('overlap_ratio');
CoM_Nowacki2022 = psm_Nowacki2019.results.CoM;
psm_Nowacki2022 = [];

%% figure 4

data = [R2_Nguyen2019, R2_Dembek2019, R2_Reich2019, R2_Nowacki2022];
variableNames = {'Nguyen et al., 2019', 'Dembek et al., 2019', 'Reich et al., 2019', 'Nowacki et al., 2022'};

figure('Name', 'results_3')
boxplot(data, variableNames);

%% figure 6

CoM_Nguyen2019 = [ 10, -12, -8;
        10, -12, -7;
        10, -12, -6;
        10, -12, -5;
        10, -12, -4];

CoM_Dembek2019 = 1+[ 10, -12, -8;
        10, -12, -7;
        10, -12, -6;
        10, -12, -5;
        10, -12, -4];

CoM_Reich2019 = 2+[ 10, -12, -8;
        10, -12, -7;
        10, -12, -6;
        10, -12, -5;
        10, -12, -4];

CoM_Nowacki2022 = 3+[ 10, -12, -8;
        10, -12, -7;
        10, -12, -6;
        10, -12, -5;
        10, -12, -4];

CoM = {CoM_Nguyen2019, CoM_Dembek2019, CoM_Reich2019, CoM_Nowacki2022};

colors = [0, 0.4470, 0.7410; 
          0.9290, 0.6940, 0.1250;
	      0.4660, 0.6740, 0.1880;
	      0.6350, 0.0780, 0.1840];

gcf
hold on

for k = 1:4
    
    scatter3(CoM{k}(:, 1), CoM{k}(:, 2), CoM{k}(:, 3), 30, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	colors(k, :))
    
    scatter3(mean(CoM{k}(:, 1)), mean(CoM{k}(:, 2)), mean(CoM{k}(:, 3)), 100, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	colors(k, :))

end



