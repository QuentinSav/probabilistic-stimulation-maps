clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');
tableMulticentric(1:600, :) = [];

psm = PSM(tableMulticentric, ...
    'mode', 'analysis', ...
    'algorithm', 'Proposed', ...
    'hemisphere', 'both', ...
    'bypassCheck', true);

psm.compute();
psm.evaluate();
psm.show_image('SweetSpot')

%%
load './templates/learned_theta.mat'