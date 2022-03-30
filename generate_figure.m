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

%%

psm_Nguyen2019.compute();
R2_Nguyen2019 = psm_Nguyen2019.evaluate('overlap_ratio');


%%
psm_Dembek2019.compute();
psm_Dembek2019 = [];

psm_Reich2019.compute();
psm_Reich2019 = [];

psm_Nowacki2022.compute();
psm_Nowacki2022 = [];

