clc;
clear all;
close all;

% load table
load('multicentricTableAllImprovedOnlyRev04.mat');

%% Bern
tableBern = tableMulticentric(tableMulticentric.centerID == 1, :);

figure;
scatter(tableMulticentric.amplitude, tableMulticentric.relativeImprovement);

%% Cologne
tableCologne = tableMulticentric(centerID == 2);
