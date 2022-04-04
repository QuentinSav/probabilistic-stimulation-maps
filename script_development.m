% load table

%% Image result 1

load('../../03_Data/01_Tables/multicentricTableAllImprovedOnlyRev05.mat');

psm = PSM(tableMulticentric, ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0, ...
    'mode', 'analysis');

voxsizes = [5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]/10;
for k = 1:length(voxsizes)
psm.createPreprocessedCSV(voxsizes(k));
end