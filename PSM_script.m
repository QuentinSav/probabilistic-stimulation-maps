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
psm = PSM(tableMulticentric);

psm = PSM(tableMulticentric, ...
    'hemisphere', 'Left');

psm = PSM(tableMulticentric, ...
    'algorithm', 'Nguyen, 2019', ...
    'hemisphere', 'Left');

psm = PSM(tableMulticentric, ...
    'mode', 'analysis', ...
    'algorithm', 'Nguyen, 2019', ...
    'hemisphere', 'Left');

% Call the function compute_map will lauch the computation of the PSM
tic;
psm.compute_map();
toc;

   
