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
disp('Multicenter --------------------------------------------------------')
figure('Name', 'fig_2A_multi', ...
        'Position', [200 200 350 350]);
s = scatter(tableMulticentric.amplitude, tableMulticentric.relativeImprovement, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Relative improvement (%)');

[rho_s_imp, p_s_imp] = corr(tableMulticentric.amplitude, tableMulticentric.relativeImprovement, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableMulticentric.amplitude, tableMulticentric.relativeImprovement, 'Type', 'Pearson');

disp(['Correlation between PA and relative improvement: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])


figure('Name', 'fig_2B_multi', ...
        'Position', [200 200 350 350]);
s = scatter(tableMulticentric.amplitude, tableMulticentric.efficiency, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Efficiency (-)');

[rho_s_imp, p_s_imp] = corr(tableMulticentric.amplitude, tableMulticentric.efficiency, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableMulticentric.amplitude, tableMulticentric.efficiency, 'Type', 'Pearson');

disp(['Correlation between PA and efficiency: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])

% Bern
disp('Bern ---------------------------------------------------------------')
tableBern = tableMulticentric(tableMulticentric.centerID == 1, :);

figure('Name', 'fig_2C_Bern', ...
        'Position', [200 200 350 350]);
s = scatter(tableBern.amplitude, tableBern.relativeImprovement, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Relative improvement (%)');

[rho_s_imp, p_s_imp] = corr(tableBern.amplitude, tableBern.relativeImprovement, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableBern.amplitude, tableBern.relativeImprovement, 'Type', 'Pearson');

disp(['Correlation between PA and relative improvement: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])


figure('Name', 'fig_2D_Bern', ...
        'Position', [200 200 350 350]);
s = scatter(tableBern.amplitude, tableBern.efficiency, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Efficiency (-)');

[rho_s_imp, p_s_imp] = corr(tableBern.amplitude, tableBern.efficiency, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableBern.amplitude, tableBern.efficiency, 'Type', 'Pearson');

disp(['Correlation between PA and efficiency: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])

% Cologne
disp('Cologne ------------------------------------------------------------')
tableCologne = tableMulticentric(tableMulticentric.centerID == 2, :);

figure('Name', 'fig_2E_Cologne', ...
        'Position', [200 200 350 350]);
s = scatter(tableCologne.amplitude, tableCologne.relativeImprovement, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Relative improvement (%)');

[rho_s_imp, p_s_imp] = corr(tableCologne.amplitude, tableCologne.relativeImprovement, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableCologne.amplitude, tableCologne.relativeImprovement, 'Type', 'Pearson');

disp(['Correlation between PA and relative improvement: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])


figure('Name', 'fig_2F_Cologne', ...
        'Position', [200 200 350 350]);
s = scatter(tableCologne.amplitude, tableCologne.efficiency, 6, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	[102 153 204]/255);

xlabel('Pulse amplitude (mA)');
ylabel('Efficiency (-)');

[rho_s_imp, p_s_imp] = corr(tableCologne.amplitude, tableCologne.efficiency, 'Type', 'Spearman');
[rho_p_imp, p_p_imp] = corr(tableCologne.amplitude, tableCologne.efficiency, 'Type', 'Pearson');

disp(['Correlation between PA and efficiency: ']);
disp(['    (spearman) rho = ', num2str(rho_s_imp), ' (p = ', num2str(p_s_imp), ')'])
disp(['    (pearson)  rho = ', num2str(rho_p_imp), ' (p = ', num2str(p_p_imp), ')'])

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
CoM_Nguyen2019 = psm_Nguyen2019.results.CoM;psm_Nguyen2019.show_image('SweetSpot');
psm_Nguyen2019 = [];

psm_Dembek2019.compute();
R2_Dembek2019 = psm_Dembek2019.evaluate('overlap_ratio');
CoM_Dembek2019 = psm_Dembek2019.results.CoM;
psm_Dembek2019.show_image('SweetSpot');
psm_Dembek2019 = [];

psm_Reich2019.compute();
R2_Reich2019 = psm_Reich2019.evaluate('overlap_ratio');
CoM_Reich2019 = psm_Reich2019.results.CoM;
psm_Reich2019.show_image('SweetSpot');
psm_Reich2019 = [];

psm_Nowacki2022.compute();
R2_Nowacki2022 = psm_Nowacki2022.evaluate('overlap_ratio');
CoM_Nowacki2022 = psm_Nowacki2022.results.CoM;
psm_Nowacki2022.show_image('SweetSpot');
psm_Nowacki2022 = [];


%% figure 4

data = [R2_Nguyen2019; R2_Dembek2019; R2_Reich2019; R2_Nowacki2022]';
variableNames = {'Nguyen et al., 2019', 'Dembek et al., 2019', 'Reich et al., 2019', 'Nowacki et al., 2022'};

figure('Name', 'results_3')
boxplot(data, variableNames);
ylabel('Coefficient of determination R²')

%% figure 6

CoM = {CoM_Nguyen2019, CoM_Dembek2019, CoM_Reich2019, CoM_Nowacki2022};

colors = [0, 0.4470, 0.7410; 
          0.9290, 0.6940, 0.1250;
	      0.4660, 0.6740, 0.1880;
	      0.6350, 0.0780, 0.1840];

gcf
hold on

for k = 1:4
    
    scatter3(CoM{k}(:, 1), CoM{k}(:, 2), CoM{k}(:, 3), 60, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	colors(k, :))
    
    scatter3(nanmean(CoM{k}(:, 1)), nanmean(CoM{k}(:, 2)), nanmean(CoM{k}(:, 3)), 200, ...
        'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	colors(k, :))

end

% Dummy graph for the legend
figure
hold on
for k = 1:4
    
scatter(1,1, 'o', ...
        'MarkerEdgeColor', 'None', ...
        'MarkerFaceColor', 	colors(k, :))
end

legend({'Nguyen et al., 2019', 'Debek et al., 2019',  'Reich et al. 2019', 'Nowacki et al. 2022'})