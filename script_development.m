% load table

%% Image result 1

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

R2_relImp = fun_evaluate_Nguyen2019_eff_vs_relImp(psm_rImp, 'relImp');
R2_eff = fun_evaluate_Nguyen2019_eff_vs_relImp(psm_eff, 'eff');

disp('R2 overlap with efficiency Sweet spot: ')
disp(['eff  = ', num2str(R2_eff(1))]);   
disp(['rImp = ', num2str(R2_eff(2))]);    

disp('R2 overlap with relative improvement Sweet spot: ')
disp(['eff  = ', num2str(R2_relImp(1))]);   
disp(['rImp = ', num2str(R2_relImp(2))]);    

