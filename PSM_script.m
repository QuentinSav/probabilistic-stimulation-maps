clc;
clear all;
close all;

tic

% Create PSM instance
psm = PSM('algorithm', 'Reich, 2019', 'hemisphere', 'Left');
psm.compute_map();
psm.showResults('weightedSum');
psm.showResults('overlapRatio');

toc










%%
% check the overlap calculation                                        DONE
% 
% n-image and mean-image computation                                   DONE
% 
% Statistical test:                                                    TODO
%    - Wilcoxon sign rank test,                                        DONE
%    - Mann-Whitney U test                                             TODO
%
% Null-hypothesis:                                                     TODO     
%    - zero,                                                           DONE
%    - mean efficacy of the same amplitude VTAs,                       DONE
%    - mean efficacy of all VTAs that do not include a specific voxel, TODO
%    - custom                                                          TODO
%
% Type 1 error correction:                                             TODO   
%    - false discovery rate                                            DONE
%    - Bonferroni correction                                           DONE
%    - permutation tests                                               TODO    
