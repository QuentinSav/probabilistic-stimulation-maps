function [nImage, meanImage, h0Image] = compute_nmhImage(obj)
% Input:        - None
% Output:       - nImage and meanImage

% Computes the mean of each stim amplitudes

disp('--------------------------------------------------');
disp('Computing n-image, mean-image, h0-image');

mniVoxels = [];
clinicalEfficiencies = [];
stimulationAmplitudes = [];
VTAindex = [];

nDigit = 0;

for k = 1:obj.nTrainingData
    if mod(k, 10) == 0 || k == obj.nTrainingData
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.nTrainingData);
    end

    % Load the VTA NIFTI file
    VTA = obj.loadVTA(k);
    voxelSize = obj.get_voxelSize(VTA.mat);

    % TODO: add a check for the voxel size (it must always be the same)

    VTA.img = round(VTA.img);

    % Find the voxels coordinates of the VTA
    ptCloudVTA = obj.nii2ptCloud(VTA, 'array', 'mni');

    % TODO rename
    mniVoxels = [mniVoxels; round(ptCloudVTA.coord./voxelSize)];
    clinicalEfficiencies = [clinicalEfficiencies, ones(1, length(ptCloudVTA.coord)).*obj.trainingData.efficiency(k)];
    stimulationAmplitudes = [stimulationAmplitudes, ones(1, length(ptCloudVTA.coord)).*obj.trainingData.amplitude(k)];
    VTAindex = [VTAindex, ones(1, length(ptCloudVTA.coord)).*k];

end

% Find the range of voxel indexs
offset = min(mniVoxels) - ones(1,3);
max_index = max(mniVoxels);

% Get h0
i = 1;
for k = 0:0.25:max(obj.trainingData.amplitude)

    meanEfficiency = mean(obj.trainingData.efficiency(obj.trainingData.amplitude == k));
    meanEfficienciesArray(i, :) = [k, meanEfficiency];

    i = i + 1;

end

% Initialize map
nMap = zeros(max_index - offset);
meanMap = zeros(max_index - offset);
h0Map = zeros(max_index - offset);
eMap = NaN([max_index - offset, obj.nData]);

% Compute map
nVoxels = length(mniVoxels);
nDigit = 0;

% TODO: speed up this loop
for k = 1:nVoxels

    % Print only for multiples of 10'000
    if mod(k, 100000) == 0 || k == nVoxels
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Processing voxel # %d / %d\n', k, nVoxels);
    end

    voxelIndex = mniVoxels(k, :) - offset;
    nMap(voxelIndex(1), voxelIndex(2), voxelIndex(3)) = nMap(voxelIndex(1), voxelIndex(2), voxelIndex(3)) + 1;
    meanMap(voxelIndex(1), voxelIndex(2), voxelIndex(3)) = meanMap(voxelIndex(1), voxelIndex(2), voxelIndex(3)) + clinicalEfficiencies(k);

    stimulationAmplitude = stimulationAmplitudes(k);
    meanEfficiency = meanEfficienciesArray(meanEfficienciesArray(:, 1) == stimulationAmplitude, 2);
    h0Map(voxelIndex(1), voxelIndex(2), voxelIndex(3)) = h0Map(voxelIndex(1), voxelIndex(2), voxelIndex(3)) + meanEfficiency;
    eMap(voxelIndex(1), voxelIndex(2), voxelIndex(3), VTAindex(k)) = clinicalEfficiencies(k);

end

meanMap = meanMap/obj.nData;
h0Map = h0Map/obj.nData;

obj.eImage = eMap;

% Create NIFTI image with the mean-image
obj.meanImage = ea_make_nii(meanMap, VTA.voxsize, - offset);
obj.meanImage.mat = diag([VTA.voxsize, 1]);
obj.meanImage.mat(1:3, 4) = offset.*voxelSize;

% Create NIFTI image with the n-image
obj.nImage = ea_make_nii(nMap, VTA.voxsize, - offset);
obj.nImage.mat = diag([VTA.voxsize, 1]);
obj.nImage.mat(1:3, 4) = offset.*voxelSize;

% Create NIFTI image with the h0-image
obj.h0Image = ea_make_nii(h0Map, VTA.voxsize, - offset);
obj.h0Image.mat = diag([VTA.voxsize, 1]);
obj.h0Image.mat(1:3, 4) = offset.*voxelSize;

% Assign the output variable
nImage = obj.nImage;
meanImage = obj.meanImage;
h0Image = obj.h0Image;

end