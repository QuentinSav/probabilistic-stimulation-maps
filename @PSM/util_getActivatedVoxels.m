function activatedVoxels = util_getActivatedVoxels(obj)
% Get the 

nDigit = 0;

% Loop over the current training data
for k = 1:obj.data.training.n

    % Progress feedback to the user
    if mod(k, 10) == 0 || k == obj.data.training.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('VTA # %d / %d\n', k, obj.data.training.n);
    end

    % Load the VTA NIFTI file (already filtered in the load function)
    VTA = obj.util_loadVTA(k);

    % Find the voxels coordinates of the VTA
    activatedVoxelsCells{k} = PSM.util_nii2voxelArray(VTA, 'coord', 'mni');
    indexVTAsCells{k} = k.*ones(activatedVoxelsCells{k}.n, 1);

end

% Concatenate all the cell containing the voxel list
activatedVoxelsCells= cat(1, activatedVoxelsCells{:});

% Initialize field
activatedVoxels.indexVTAs = [];

% The activatedVoxel array contains the MNI coordinates of each activated voxel
activatedVoxels.coord = cat(1, activatedVoxelsCells(:).coord);
activatedVoxels.weights = cat(1, activatedVoxelsCells(:).intensity);
activatedVoxels.indexVTAs = cat(1, indexVTAsCells{:});

end