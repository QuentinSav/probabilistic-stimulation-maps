function status = check_voxsize(obj)
    % For the use of the PSM class, the VTAs shall be already preprocessed
    % and have the same voxel size.
    % This function check the voxel size all the VTA from the data.
    % Return 1 in case, all the voxel size are the same and return 0 
    % otherwise.
    
    status = 1;
    obj.state = 'idle';
    
    VTA = obj.loadVTA(1);
    expectedVoxelSize = obj.get_voxelSize(VTA.mat);
    
    nDigit = 0;
    
    for k = 1:obj.nData
        if mod(k, 10) == 0 || k == obj.nData
            fprintf(repmat('\b', 1, nDigit))
            nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.nData);
        end
    
        VTA = obj.loadVTA(k);
        voxelSize = obj.get_voxelSize(VTA.mat);
    
        if voxelSize ~= expectedVoxelSize
            status = 0;
            return
        end
    end
end