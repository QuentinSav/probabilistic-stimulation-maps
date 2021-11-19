function compute_map(obj)
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
    obj.results.weightedSum.nVoxels = [];
    obj.results.weightedSum.value = [];
    obj.results.overlap.voxels = [];
    obj.results.overlap.nVoxels = [];
    obj.results.overlap.size = [];
    obj.results.overlap.ratio = [];
    obj.results.dice.similarity = [];
    obj.results.efficiency = [];
    obj.results.leadID = [];
    obj.results.kFold = [];
    
    % Create the data partition for validation
    hPartition = obj.pipeline.validationMethod{1}();
    
    for k = 1:hPartition.NumTestSets
        
        obj.kFold = k;

        disp('==================================================');
        disp("Cross-validation fold # " + k + "/" + hPartition.NumTestSets);
    
        % Creates training set
        indexTrain = training(hPartition, k);
        obj.trainingData = obj.clinicalData(indexTrain, :);
        obj.nTrainingData = height(obj.trainingData);
    
        % Creates validation set
        indexValid = test(hPartition, k);
        obj.validationData = obj.clinicalData(indexValid, :);
        obj.nValidationData = height(obj.validationData);
        
        obj.train();
        obj.test();
    
    end
end