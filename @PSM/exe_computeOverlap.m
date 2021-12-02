function exe_computeOverlap(obj)

nDigit = 0;

for k = 1:obj.data.testing.n
    if mod(k, 10) == 0 || k == obj.data.testing.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.data.testing.n);
    end
    
    % Load the VTA
    VTA = obj.util_loadVTA(k);
    voxelSize = obj.util_getVoxelSize(VTA.mat);
    
    % Convert images to coordinates arrays
    sweetspotVoxels = obj.util_nii2voxelArray(obj.map.sweetspot, 'coord', 'mni');
    vtaVoxels = obj.util_nii2voxelArray(VTA, 'coord', 'mni');

    % Overlap
    obj.results.overlap.voxels{end+1} = intersect(sweetspotVoxels.coord, vtaVoxels.coord, 'rows');
    obj.results.overlap.nVoxels(end+1) = size(obj.results.overlap.voxels{end}, 1);
    obj.results.overlap.size(end+1) = obj.results.overlap.nVoxels(end)*voxelSize(1)*voxelSize(2)*voxelSize(3);
    obj.results.overlap.ratio(end+1) = obj.results.overlap.nVoxels(end)/nnz(VTA.img);
    
    % Score
    obj.results.score(end+1) = obj.data.testing.table.clinicalScore(k);
    
    % K-fold
    obj.results.kFold(end+1) = obj.param.kFold;
    
    % Lead
    obj.results.leadID(end+1) = obj.data.testing.table.leadID(k);

end

end