function activatedVoxels = util_getActivatedVoxels(obj, varargin)
% Get the 

nDigit = 0;

if strcmpi(obj.state, 'training')
    batch = obj.data.training;
    
elseif strcmpi(obj.state, 'testing')
    batch = obj.data.testing;

else
    batch = obj.data.clinical;

end

% Loop over the current training data
for k = 1:batch.n

    % Progress feedback to the user
    if mod(k, 10) == 0 || k == batch.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('VTA # %d / %d\n', k, batch.n);
    end

    % Load the VTA NIFTI file (already filtered in the load function)
    VTA = obj.util_loadVTA(k);

    % Find the voxels coordinates of the VTA
    activatedVoxelsCells{k} = PSM.util_nii2voxelArray(VTA, 'coord', 'voxel');
    indexVTAsCells{k} = k.*ones(activatedVoxelsCells{k}.n, 1);
    obj.data.(obj.state).table.nVoxel(k) = activatedVoxelsCells{k}.n;

end

% Concatenate all the cell containing the voxel list
activatedVoxelsCells = cat(1, activatedVoxelsCells{:});

% Initialize field
activatedVoxels.indexVTAs = [];

% The activatedVoxel array contains the MNI coordinates of each activated voxel
activatedVoxels.coord = cat(1, activatedVoxelsCells(:).coord);
activatedVoxels.weights = cat(1, activatedVoxelsCells(:).intensity);
activatedVoxels.indexVTAs = cat(1, indexVTAsCells{:});

end