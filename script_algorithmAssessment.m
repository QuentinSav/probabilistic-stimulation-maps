clc;
clear;
close all;

load('multicentricTableAllImprovedOnlyRev04.mat');

% In this example case, the table does not include a score fields. Thus the
% table needs to be formated.
tableMulticentric = renamevars(tableMulticentric, 'efficiency', 'clinicalScore');

psmNguyenAll = PSM(tableMulticentric, ...
    'mode', 'analysis', ...
    'algorithm', 'Nguyen2019', ...
    'hemisphere', 'both', ...
    'bypassCheck', 'true');

psmDembekAll = PSM(tableMulticentric, ...
    'mode', 'analysis', ...
    'algorithm', 'Dembek2019', ...
    'hemisphere', 'both', ...
    'bypassCheck', 'true');

psmReichAll = PSM(tableMulticentric, ...
    'mode', 'analysis', ...
    'algorithm', 'Reich2019', ...
    'hemisphere', 'both', ...
    'bypassCheck', 'true');

% Compute the maps
psmNguyenAll.compute();
psmDembekAll.compute();
psmReichAll.compute();

%%
% Evaluate the maps
psmNguyenAll.evaluate();
psmDembekAll.evaluate();
psmReichAll.evaluate();

%%

% TODO
%   - on full data set
%   - on hemispheric data set
%   - less data
