function util_createPipeline(obj)
% Function used to create the pipeline for training, testing, validating
% and post-processing the probabilistic stimulation map. The 

switch obj.algorithm
    case 'Nguyen2019' % ---------------------------------------------------
        
        % Define training pipeline
        obj.pipeline.training = {
            @(method) obj.util_setFilter( ...
                'rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray'}), ... 
            @(statTest, h0, alpha) obj.exe_computeStatTests( ...
                'exactWilcoxon', ...
                'zero', ...
                0.05), ...
            @(method) obj.exe_computeFalsePosCorrection( ...
                'Benjamini-Hochberg'), ...
            @obj.exe_computeSignMeanImage, ...
            @(method) obj.exe_computeSweetSpot( ...
                'percentile', ...
                90)};
        
        % Define testing pipeline
        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};
        
        % Define validation mehtod
        obj.pipeline.validation = { ...
            @(method, KFold) obj.util_getValidPartition( ...
                'KFold', ...
                5)};
        
        % Define model evaluation method
        obj.pipeline.evaluation = {};

    case 'Dembek2019' % ---------------------------------------------------
        
        % Define training pipeline
        obj.pipeline.training = { ...
            @(method) obj.util_setFilter( ...
                'rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores', ...
                'meanScoreSameAmp', ...
                'stimAmplitudes'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray', ...
                'h0MeanScoreSameAmp'}), ...
            @(minN) obj.exe_thresholdImages( ...
                16), ...
            @(statTest, h0Type, alpha) obj.exe_computeStatTests( ...
                'approxWilcoxon', ...
                'h0MeanScoreAmplitude', ...
                0.05), ...
            @(method, nPermutations) obj.exe_computeFalsePosCorrection( ...
                'No correction', ...
                10), ...
            @obj.exe_computeSignMeanImage, ...
            @(method) obj.exe_computeSweetSpot( ...
                'largestCluster')};
        
        % Define testing pipeline
        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};
        
        % Define validation method
        obj.pipeline.validation = { ...
            @(method, ratio) obj.util_getValidPartition( ...
                'Out-of-sample', ...
                0.2)};
        
        % Define model evaluation method
        obj.pipeline.evaluation = {};

    case 'Reich2019' % ----------------------------------------------------

        % Define training pipeline
        obj.pipeline.training = {
            @(method) obj.util_setFilter( ...
                'rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray', ...
                'h0ScoresExcludeVox'}), ...
            @(minN) obj.exe_thresholdImages( ...
                15), ...
            @(statTest, h0Type, alpha) obj.exe_computeStatTests( ...
                't-test', ...
                'h0ScoresExcludeVox', ...
                0.05), ...
            @(method) obj.exe_computeFalsePosCorrection( ...
                'No correction'), ...
            @obj.exe_computeSignMeanImage, ...
            @(method) obj.exe_computeSweetSpot( ...
                'largestCluster')};
        
        % Define testing pipeline
        obj.pipeline.testing = { ...
            @obj.exe_computeOverlap};
        
        % Define validation method
        obj.pipeline.validation = { ...
            @(method, ratio) obj.util_getValidPartition( ...
                'Out-of-sample', ...
                0.2)};
        
        % Define model evaluation method
        obj.pipeline.evaluation = {};

    case 'Proposed' % Savary2021 ------------------------------------------
        
        % Define training pipeline
        obj.pipeline.training = {
            @(method) obj.util_setFilter( ...
                'rounded'), ...
            @(features) obj.exe_compileFeatures( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'scores'}), ...
            @(images) obj.exe_computeFeatureImages( ...
                {'n', ...
                'mean', ...
                'scoresArray'})};

end
end