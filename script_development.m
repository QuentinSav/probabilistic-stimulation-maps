% load table

%% Image result 1

load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev04.mat');

tableMulticentric = renamevars(tableMulticentric, "relativeImprovement", "clinicalScore");

psm = PSM(tableMulticentric(1:100, :), ...
    'algorithm', 'Nguyen2019', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

psm.compute();



