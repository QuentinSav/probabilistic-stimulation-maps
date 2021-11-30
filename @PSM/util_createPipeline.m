function util_createPipeline(obj)
% Function used to create the pipeline for training, testing, validating
% and post-processing the probabilistic stimulation map. The 

switch obj.algorithm
    case 'Nguyen2019'
        
        % Define parameters
        obj.param.alpha = 0.05;

        obj.pipeline.training = {
            @(method) obj.util_setFilter('rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray'}), ... 
            @(statTest, h0) obj.exe_computeStatTests('exactWilcoxon', 'zero'), ...
            @(method) obj.exe_computeFalsePosCorrection('Benjamini-Hochberg'), ...
            @obj.exe_computeSignMeanImage};

        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};

        obj.pipeline.validation = { ...
            @(method, KFold) obj.util_getValidPartition('KFold', 5)};
        
        obj.pipeline.evaluation = {};

    case 'Dembek2019'
        
        % Define parameters
        obj.param.alpha = 0.05;
        obj.param.nPermutationImages = 10;

        obj.pipeline.training = {
            @(method) obj.util_setFilter('rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores', ...
                'meanScoreSameAmp', ...
                'stimAmplitudes', ...
                'permutedScores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray', ...
                'h0MeanScoreSameAmp', ...
                'permutation'}), ...
            @(minN) obj.exe_thresholdImages(15), ...
            @(statTest, h0Type) obj.exe_computeStatTests('approxWilcoxon', 'h0MeanScoreAmplitude'), ...
            @(method) obj.exe_computeFalsePosCorrection('Permutation Test'), ...
            @obj.exe_computeSignMeanImage};

        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};

        obj.pipeline.validation = { ...
            @(method, ratio) obj.util_getValidPartition('Out-of-sample', 0.2)};
        
        obj.pipeline.evaluation = {};

    case 'Reich2019'
        
        % Define parameters
        obj.param.alpha = 0.05;

        obj.pipeline.training = {
            @(method) obj.util_setFilter('rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray', ...
                'h0_scoresExcludeVox'}), ...
            @(minN) obj.exe_thresholdImages(15), ...
            @(statTest, h0Type) obj.exe_computeStatTests('t-test', 'h0_scoresExcludeVox'), ...
            @(method) obj.exe_computeFalsePosCorrection('No correction'), ...
            @obj.exe_computeSignMeanImage};
        
        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};
        
        obj.pipeline.validation = { ...
            @(method, ratio) obj.util_getValidPartition('Out-of-sample', 0.2)};
        
        obj.pipeline.evaluation = {};

    case 'Proposed'

end
end