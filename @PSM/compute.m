function compute(obj)
    % High-level function that launch the computation of the map
    
    % Will not allow the map computation in case the VTA do not have the
    % same voxel size
    if strcmpi(obj.state, 'error')
        
        warning(['The map cannot be computed because the VTA voxel ' ...
            'size are not consistent. Reslice all VTAs before ' ...
            'computing the map.']);
        return;

    end

    % Initialize results array
    obj.results.overlap.voxels = [];
    obj.results.overlap.nVoxels = [];
    obj.results.overlap.size = [];
    obj.results.overlap.ratio = [];
    obj.results.score = [];
    obj.results.leadID = [];
    obj.results.kFold = [];
    obj.results.logRegression = [];
    
    % Create the data partition for validation
    hPartition = obj.pipeline.validation{1}();
    
    for k = 1:hPartition.NumTestSets
        
        obj.param.kFold = k;

        disp('==================================================');
        disp("Cross-validation fold # " + k + "/" + hPartition.NumTestSets);
    
        % Creates training set
        indexTrain = training(hPartition, k);
        obj.data.training.table = obj.data.clinical.table(indexTrain, :);
        obj.data.training.n = height(obj.data.training.table);
    
        % Creates test set
        indexTest = test(hPartition, k);
        obj.data.testing.table = obj.data.clinical.table(indexTest, :);
        obj.data.testing.n = height(obj.data.testing.table);
        
        obj.train();
        obj.test();
    
    end
end