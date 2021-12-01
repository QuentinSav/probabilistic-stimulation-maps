clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');

psm = PSM(tableMulticentric(1:40, :), ...
    'mode', 'analysis', ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'both', ...
    'bypassCheck', true);

psm.compute();
psm.evaluate();
