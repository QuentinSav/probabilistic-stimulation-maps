function get_features(obj, features)

disp('--------------------------------------------------');
disp('Extracting features');

% Load the first VTA NIFTI file to define the voxel size
VTA = obj.loadVTA(1);
obj.param.voxelSize = obj.get_voxelSize(VTA.mat);

nDigit = 0;

% Loop over the current training data
for k = 1:obj.data.training.n

    % Progress feedback to the user
    if mod(k, 10) == 0 || k == obj.data.training.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('VTA # %d / %d\n', k, obj.data.training.n);
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
coord = coord./obj.param.voxelSize;

% Find the min values of the coordinates in order to shift it to zero
obj.features.containerOffset = min(coord) - ones(1,3);

% Shift the voxel coordinates
obj.features.coord = coord - obj.features.containerOffset;

% Get the size of the array
obj.features.containerSize = max(obj.features.coord);


if any(strcmp(features, 'indexVTAs'))
    obj.features.indexVTAs  = indexVTAs;

end

if any(strcmp(features, 'weights'))
    obj.features.weights = cat(1, activatedVoxels(:).intensity);

end

if any(strcmp(features, 'efficiencies'))
    obj.features.scores = obj.data.training.table.clinicalScore(indexVTAs);

end

if any(strcmp(features, 'stimAmplitudes'))
    obj.features.stimAmplitudes = obj.data.training.table.amplitude(indexVTAs);

end

if any(strcmp(features, 'meanEffAmplitudes'))

    amplitudeKeys = unique(obj.trainingData.amplitude);

    for k = 1:length(amplitudeKeys)
        meanScoresValues(k) = mean(obj.trainingData.score(obj.trainingData.amplitude == amplitudeKeys(k)));

    end

    meanScoresMap = containers.Map(amplitudeKeys, meanScoreValues);
    obj.features.meanScores = NaN(obj.features.n, 1);

    nDigit = 0;

    for k = 1:obj.features.n

        if mod(k, 10000) == 0 || k == obj.features.n
            fprintf(repmat('\b', 1, nDigit))
            nDigit = fprintf('Mean-Score: Processing voxel # %d / %d\n', k, obj.features.n);
        end

        obj.features.meanScores(k) = meanScoresMap(obj.features.stimAmplitudes(k));

    end
end

if any(strcmp(features, 'arrayVTA'))

    obj.get_arrayVTA()

end

end


