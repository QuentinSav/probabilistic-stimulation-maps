function test(obj)
disp('--------------------------------------------------');
disp('TESTING');

obj.state = 'validation';

nDigit = 0;

for k = 1:obj.nValidationData
    if mod(k, 10) == 0 || k == obj.nValidationData
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.nValidationData);
    end
    
    % Load the VTA
    VTA = obj.loadVTA(k);
    voxelSize = obj.get_voxelSize(VTA.mat);
    
    % Convert images to coordinates arrays
    signMeanImageVoxels = obj.nii2voxelArray(obj.sweetspot, 'array', 'mni');
    sweetspotVoxels = obj.nii2voxelArray(obj.sweetspot, 'array', 'mni');
    vtaVoxels = obj.nii2voxelArray(VTA, 'array', 'mni');
    
    % Weighted sum
    [~, ia, ib] = intersect(signMeanImageVoxels.coord, vtaVoxels.coord, 'rows');
    obj.results.weightedSum.nVoxels(end+1) = size(ia, 1);
    obj.results.weightedSum.value(end+1) = 0;

    for l = 1:obj.results.weightedSum.nVoxels(end)
        obj.results.weightedSum.value(end) = obj.results.weightedSum.value(end) + ...
            signMeanImageVoxels.intensity(ia(l))*vtaVoxels.intensity(ib(l));
    
    end

    % Overlap
    obj.results.overlap.voxels{end+1} = intersect(sweetspotVoxels.coord, vtaVoxels.coord, 'rows');
    obj.results.overlap.nVoxels(end+1) = size(obj.results.overlap.voxels{end}, 1);
    obj.results.overlap.size(end+1) = obj.results.overlap.nVoxels(end)*voxelSize(1)*voxelSize(2)*voxelSize(3);
    obj.results.overlap.ratio(end+1) = obj.results.overlap.nVoxels(end)/nnz(VTA.img);
    
    % Efficiency
    obj.results.efficiency(end+1) = obj.validationData.efficiency(k);
    
    % K-fold
    obj.results.kFold(end+1) = obj.kFold;
    
    % Lead
    obj.results.leadID(end+1) = obj.validationData.leadID(k);

    % Dice
    % TODO the sweetspot and the VTA should be the same size
    % obj.results.dice.similarity(end+1) = dice(VTA.img, obj.sweetspot.img);

end
end