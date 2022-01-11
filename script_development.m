clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');

psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 0);

psm.createPreprocessedCSV();

% psm.compute();
% psm.evaluate('predictor');
