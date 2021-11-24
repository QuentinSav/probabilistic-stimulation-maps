% Example script for PSM Class usage
clc;
clear all;
close all;

% Load a clinical data table, the table shall contain one row per VTA with
% at least the fields filename and score
load('multicentricTableAllImprovedOnlyRev04.mat');

% In this example case, the table does not include a score fields. Thus the
% table needs to be formated.
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');
    
% Then the PSM can be instantiated by specifying the table and additional
% optional parameters. Several examples below (not exhaustive, refer to the
% class documentation for more informations).
% psm = PSM(tableMulticentric);
% 
% psm = PSM(tableMulticentric, ...
%     'hemisphere', 'left');
% 
% psm = PSM(tableMulticentric, ...
%     'algorithm', 'Nguyen2019', ...
%     'hemisphere', 'left');
% 
% psm = PSM(tableMulticentric, ...
%     'mode', 'analysis', ...
%     'algorithm', 'Nguyen2019', ...
%     'hemisphere', 'left');

psm = PSM(tableMulticentric(1:100, :), ...
    'mode', 'analysis', ...
    'algorithm', 'Reich2019', ...
    'hemisphere', 'left', ...
    'bypassCheck', 'true');

% It is possible to have a preview of all the information about the map
% with the following function
psm.info();

% Call the function compute_map will lauch the computation of the PSM
tic;
psm.compute();
toc;

%%
% We can now vizualize the images. If the lead dbs 3D-renderer is open, it 
% will plot the image inside. Otherwise it will open a new figure.
% psm.show_results('overlapRatio')
psm.show_image('SweetSpot')
psm.show_image('n-image')
psm.show_image('p-image')




% It is also possible to vizualize the prediction on new samples made by
% the map.

