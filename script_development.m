clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');
% tableMulticentric(1:600, :) = [];

psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Right', ...
    'bypassCheck', true, ...
    'centerID', 1);

psm.compute();
psm.evaluate('predictorLin');

%%
load './templates/learned_theta.mat'