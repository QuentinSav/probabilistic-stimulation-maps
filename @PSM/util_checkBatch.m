function status = util_checkBatch(obj)
    % For the use of the PSM class, the VTAs shall be already preprocessed
    % and have the same voxel size.
    % This function check the voxel size all the VTA from the data.
    % Return 1 in case, all the voxel size are the same and return 0 
    % otherwise.
    
    % Define object state before loading the data
    obj.state = 'idle';
    
    % Initialize no filter
    obj.param.filterImg = @(image) image;
    
    % Initialize the status
    status = 1;
    
    % Load the first VTA and take its voxel size as reference
    VTA = obj.util_loadVTA(1);
    expectedVoxelSize = obj.util_getVoxelSize(VTA.mat);
    
    nDigit = 0;
    
    for k = 1:obj.data.clinical.n
        % Feedback to user (print only for multiples of 10)
        if mod(k, 10) == 0 || k == obj.data.clinical.n
            fprintf(repmat('\b', 1, nDigit))
            nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.data.clinical.n);
        end
        
        % Load VTA and get the voxel size
        VTA = obj.util_loadVTA(k);
        voxelSize = obj.util_getVoxelSize(VTA.mat);
        
        % Compare the voxel size of the current VTA to the reference and 
        if voxelSize ~= expectedVoxelSize
            status = 0;
            return
        end
    end
end