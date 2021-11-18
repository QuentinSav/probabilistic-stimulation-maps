function get_matVectVTA(obj)

% To be deleted
obj.features.matVectVTA = [];

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

end
