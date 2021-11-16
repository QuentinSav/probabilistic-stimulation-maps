function get_features(obj, features)

disp('--------------------------------------------------');
disp('Extracting features');

% Load the first VTA NIFTI file to define the voxel size
VTA = obj.loadVTA(1);
obj.voxelSize = obj.get_voxelSize(VTA.mat);

nDigit = 0;

% Loop over the current training data
for k = 1:obj.nTrainingData

    % Feedback of the progress
    if mod(k, 10) == 0 || k == obj.nTrainingData
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('VTA # %d / %d\n', k, obj.nTrainingData);
    end

    % Load the VTA NIFTI file (already filtered in the load function)
    VTA = obj.loadVTA(k);

    % Find the voxels coordinates of the VTA
    activatedVoxels{k} = obj.nii2voxelArray(VTA, 'array', 'mni');
    indexVTAs{k} = k.*ones(1, activatedVoxels{k}.n);

end

activatedVoxels = cat(1, activatedVoxels{:});
indexVTAs = cat(2, indexVTAs{:});

obj.features.n = length(indexVTAs);

% The activatedVoxel array contains the MNI coordinates of each activated voxel
coord = cat(1, activatedVoxels(:).coord);

% These coordinates are scaled by the inverse of voxel size in order to
% obtain a new voxel size of 1 (ie, transform all the coordinates in a
% new voxel space)
coord = coord./obj.voxelSize;

% Find the min values of the coordinates in order to shift it to zero
obj.features.coordOffset = min(coord) - ones(1,3);

% Shift the voxel coordinates
obj.features.coord = coord - obj.features.coordOffset;

% Get the size of the array
obj.features.coordSize = max(obj.features.coord);


if any(strcmp(features, 'indexVTAs'))
    obj.features.indexVTAs  = indexVTAs;

end

if any(strcmp(features, 'weights'))
    obj.features.weights = cat(1, activatedVoxels(:).intensity);

end

if any(strcmp(features, 'efficiencies'))
    obj.features.efficiencies = obj.trainingData.efficiency(indexVTAs);

end

if any(strcmp(features, 'stimAmplitudes'))
    obj.features.stimAmplitudes = obj.trainingData.amplitude(indexVTAs);

end

if any(strcmp(features, 'meanEfficiencies'))

    amplitudeKeys = unique(obj.trainingData.amplitude);

    for k = 1:length(amplitudeKeys)
        meanEfficienciesValues(k) = mean(obj.trainingData.efficiency(obj.trainingData.amplitude == amplitudeKeys(k)));

    end

    meanEfficienciesMap = containers.Map(amplitudeKeys, meanEfficienciesValues);
    obj.features.meanEfficiencies = NaN(obj.features.n, 1);

    nDigit = 0;

    for k = 1:obj.features.n

        if mod(k, 10000) == 0 || k == obj.features.n
            fprintf(repmat('\b', 1, nDigit))
            nDigit = fprintf('Mean-Efficiency: Processing voxel # %d / %d\n', k, obj.features.n);
        end

        obj.features.meanEfficiencies(k) = meanEfficienciesMap(obj.features.stimAmplitudes(k));

    end
end

if any(strcmp(features, 'arrayVTA'))

    obj.get_arrayVTA()

end

end


