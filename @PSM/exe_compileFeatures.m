function exe_compileFeatures(obj, featuresType)
% Function that compile all the features needed for the images
% computations.
% 
% Input: - features:    List of string containing the features type 
%                       to compile. Possible string {'coord', 'indexVTAs',
%                       'scores', 'stimAmplitudes', 'meanScoreSameAmp'}

disp('--------------------------------------------------');
disp('Compiling features');

if strcmpi(obj.state, 'training')
    batch = obj.data.training;
    
elseif strcmpi(obj.state, 'testing')
    batch = obj.data.testing;

else
    batch = obj.data.clinical;

end

% Load the first VTA NIFTI file to define the voxel size
VTA = obj.util_loadVTA(1);
obj.features.voxelSize = PSM.util_getVoxelSize(VTA.mat);

if any(strcmp(featuresType, 'coord')) || ...
        any(strcmp(featuresType, 'indexVTAs')) || ...
        any(strcmp(featuresType, 'weights'))
    
    activatedVoxels = obj.util_getActivatedVoxels();

end

if any(strcmp(featuresType, 'coord'))
    coord = activatedVoxels.coord;
    coord = round(coord./obj.features.voxelSize);
    
    if ~isfield(obj.map, 'containerTemplate')
        % Find the min values of the coordinates in order to shift it to zero
        obj.features.containerOffset = min(coord) - ones(1,3);

        % Shift the voxel coordinates
        obj.features.coord = coord - obj.features.containerOffset;

        % Get the size of the array
        obj.features.containerSize = max(obj.features.coord);

        % Get the total number of features
        obj.features.n = size(obj.features.coord, 1);

        % Create an image template for the images
        obj.util_createContainerTemplate();
    
    else
        % Shift the voxel coordinates
        obj.features.coord = coord - obj.features.containerOffset;
        
        % Get the total number of features
        obj.features.n = size(obj.features.coord, 1);

    end
end

if any(strcmp(featuresType, 'indexVTAs'))
    obj.features.indexVTAs = activatedVoxels.indexVTAs;
end

if any(strcmp(featuresType, 'weights'))
    obj.features.weights = activatedVoxels.weights;

end

if any(strcmp(featuresType, 'scores'))
    obj.features.scores = batch.table.clinicalScore(obj.features.indexVTAs);

end

if any(strcmp(featuresType, 'stimAmplitudes'))
    obj.features.stimAmplitudes = batch.table.amplitude(obj.features.indexVTAs);

end

if any(strcmp(featuresType, 'meanScoreSameAmp'))
    obj.features.meanScores = obj.util_getMeanScoreSameAmplitude();

end
end


