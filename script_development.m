clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');
% tableMulticentric(1:600, :) = [];

psm = PSM(tableMulticentric(1:100, :), ...
    'mode', 'standard', ...
    'algorithm', 'Proposed3', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 1);

psm.compute();
psm.evaluate('predictor');

%%
load './templates/learned_theta.mat'