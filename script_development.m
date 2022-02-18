% clc;
% clear;
% close all;


a = b
% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');

voxelSizes = linspace(0.3, 2, 18);
folderData = '/home/brainstimmaps/RESEARCH/20xx_Projects/2008_BetterMaps/03_Data/ML_datasets';

for k = 1:height(tableMulticentric)
    tableMulticentric.filename{k} = ['../../03_Data/reslicedVTAs/1500um/', num2str(k), '.nii'];
end

psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0);

% psm.compute();
% psm.evaluate('predictor');

for k = 1:length(voxelSizes)
    
    psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Left', ...
    'bypassCheck', true, ...
    'centerID', 0);

    psm.createPreprocessedCSV(voxelSizes(k));
    
    % Plot une VTA 
    VTA_saved = psm.util_loadVTA(1);
    
    %psm.show_image(VTA)

    drawnow
end

% psm.compute();
% psm.evaluate('predictor');

%%
load('../../03_Data/ML_datasets/trilinear_interpolation/dataset_1500um.mat')

VTA_dataset.mat = container_affine;
VTA_dataset.img = reshape(X(1, 2:end), ...
    container_shape(1), ...
    container_shape(2), ...
    container_shape(3));

% Plot une VTA 
psm.util_setFilter('raw');
psm.state = 'idle';
VTA_saved = psm.util_loadVTA(1);
    
psm.show_image(VTA_saved);
psm.show_image(VTA_dataset);
