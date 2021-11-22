function exe_compileFeatures(obj, features)
% Function that 
% 
% Input: - obj
%        - features:    List of string containing the features type 
%                       to compile. Possible string {'coord', 'indexVTAs',
%                       'scores', 'stimAmplitudes', ''}

disp('--------------------------------------------------');
disp('Compiling features');

% Load the first VTA NIFTI file to define the voxel size
VTA = obj.util_loadVTA(1);
obj.features.voxelSize = obj.get_voxelSize(VTA.mat);



if any(strcmp(features, 'coord')) && any(strcmp(features, 'indexVTAs'))
    [obj.features.coord, obj.features.indexVTAs] = obj.util_getActivatedVoxels;

elseif any(strcmp(features, 'coord')) && ~any(strcmp(features, 'indexVTAs'))
    [obj.features.coord, ~] = obj.util_getActivatedVoxels;

elseif ~any(strcmp(features, 'coord')) && any(strcmp(features, 'indexVTAs'))
    [~, obj.features.indexVTAs] = obj.util_getActivatedVoxels;

end

if any(strcmp(features, 'weights'))
    obj.features.weights = cat(1, activatedVoxels(:).intensity);

end

if any(strcmp(features, 'scores'))
    obj.features.scores = obj.data.training.table.clinicalScore(indexVTAs);

end

if any(strcmp(features, 'stimAmplitudes'))
    obj.features.stimAmplitudes = obj.data.training.table.amplitude(indexVTAs);

end

if any(strcmp(features, 'meanScoreSameAmp'))
    obj.features.meanScores = meanScoresMap(obj.features.stimAmplitudes(k));

end

end


