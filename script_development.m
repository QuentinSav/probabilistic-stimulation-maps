clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');

psm = PSM(tableMulticentric(1:100, :), ...
    'mode', 'analysis', ...
    'algorithm', 'Proposed', ...
    'hemisphere', 'both', ...
    'bypassCheck', true);

psm.compute();
psm.evaluate();
psm.show_image('SweetSpot')

%%
load './templates/learned_theta.mat'