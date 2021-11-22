function [] = util_getActivatedVoxels(obj)
nDigit = 0;

% Loop over the current training data
for k = 1:obj.data.training.n
-
    % Progress feedback to the user
    if mod(k, 10) == 0 || k == obj.data.training.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('VTA # %d / %d\n', k, obj.data.training.n);
    end

    % Load the VTA NIFTI file (already filtered in the load function)
    VTA = obj.loadVTA(k);

    % Find the voxels coordinates of the VTA
    activatedVoxels{k} = obj.nii2voxelArray(VTA, 'array', 'mni');
    indexVTAs{k} = k.*ones(activatedVoxels{k}.n, 1);

end

% Concatenate all the cell containing the voxel list
activatedVoxels = cat(1, activatedVoxels{:});
indexVTAs = cat(1, indexVTAs{:});

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
end