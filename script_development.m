clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');

psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed3', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0);

psm.compute();
psm.evaluate('predictor');
