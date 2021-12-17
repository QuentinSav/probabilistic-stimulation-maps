clc;
clear;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');
tableMulticentric = renamevars(tableMulticentric, 'relativeImprovement', 'clinicalScore');
% tableMulticentric(1:600, :) = [];


psm = PSM(tableMulticentric, ...
    'mode', 'standard', ...
    'algorithm', 'Proposed1', ...
    'hemisphere', 'Both', ...
    'bypassCheck', true, ...
    'centerID', 1);

psm.compute();
psm.evaluate('predictor');


