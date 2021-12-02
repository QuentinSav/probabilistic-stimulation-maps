clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');

psm = PSM(tableMulticentric(1:50, :), ...
    'mode', 'analysis', ...
    'algorithm', 'Proposed', ...
    'hemisphere', 'both', ...
    'bypassCheck', true);

psm.compute();
psm.evaluate();
psm.show_image('SweetSpot')
