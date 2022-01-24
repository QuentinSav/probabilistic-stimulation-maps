% clc;
% clear;
% close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');

voxelSizes = linspace(0.5, 5, 10);

psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0);

for k = 1:length(voxelSizes)
    
    psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0);

    psm.createPreprocessedCSV(voxelSizes(k));

    psm = [];
    
    % Plot une VTA 
end
% psm.compute();
% psm.evaluate('predictor');
