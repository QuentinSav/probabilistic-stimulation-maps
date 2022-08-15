% load table

[~, a] = system('python3 -c ''from PSM import train_elastic_net; train_elastic_net()''');

%% Image result 1

load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev04.mat');

tableMulticentric = renamevars(tableMulticentric, "relativeImprovement", "clinicalScore");

psm = PSM(tableMulticentric(1:100, :), ...
    'algorithm', 'Nguyen2019', ...
    'bypassCheck', true);

psm.createPreprocessedCSV();
%psm.compute();
