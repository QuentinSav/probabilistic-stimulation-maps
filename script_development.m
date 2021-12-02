clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');

psm = PSM(tableMulticentric(1:50, :), ...
    'mode', 'analysis', ...
    'algorithm', 'Dembek2019', ...
    'hemisphere', 'both', ...
    'bypassCheck', true, ...
    'centerID', 0);

psm.compute();
psm.evaluate();
psm.show_image('SweetSpot')
