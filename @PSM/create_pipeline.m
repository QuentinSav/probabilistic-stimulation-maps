function create_pipeline(obj)

switch obj.algorithm
    case 'Nguyen, 2019'

        obj.pipeline.training = {
            @(method) obj.set_filter('rounded'), ...
            @(features) obj.get_features( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'efficiencies'}), ...
            @(images) obj.compute_featureImages( ...
                {'n', ...
                'mean', ...
                'eArray'}), ... 
            @(statTest, h0) obj.compute_pImage('exactWilcoxon', 'zero'), ...
            @(method) obj.type1ErrorCorrection('Benjamini-Hochberg'), ...
            @obj.compute_significantMeanImage};

        obj.pipeline.testing = {
            };

        obj.pipeline.validationMethod = {@(method, KFold) obj.crossValidation('KFold', 5)};


    case 'Dembek, 2019'

        obj.pipeline.training = {
            @(method) obj.set_filter('rounded'), ...
            @(features) obj.get_features( ...
                {'coord', ...
                'indexVTAs', ...
                'weights', ...
                'efficiencies', ...
                'meanEffAmplitudes', ...
                'stimAmplitudes'}), ...
            @(method, images) obj.compute_featureImages( ...
                {'n', ...
                'mean', ...
                'eArray', ...
                'h0_meanEffAmplitude'}), ...     
            @(minN) obj.threshold(15), ...
            @(statTest, h0Type) obj.compute_pImage('approxWilcoxon', 'h0_meanEffAmplitude'), ...
            @(method) obj.type1ErrorCorrection('No correction'), ...
            @obj.compute_significantMeanImage};
        
        obj.pipeline.testing = {
            };

        obj.pipeline.validationMethod = {@(method, ratio) obj.crossValidation('Out-of-sample', 0.2)};

    case 'Reich, 2019'
        
        obj.pipeline.training = {
            @(method) obj.set_filter('rounded'), ...
            @(features) obj.get_features( ...
                {'coord', ...
                'indexVTA', ...
                'weights', ...
                'efficiencies', ...
                'meanEffExcludeVox', ...
                'stimAmplitudes'}), ...
            @(method, images) obj.compute_featureImages( ...
                {'n', ...
                'mean', ...
                'eArray', ...
                'h0_meanEffExcludeVox'}), ...     
            @(minN) obj.threshold(15), ...
            @(statTest, h0Type) obj.compute_pImage('approxWilcoxon', 'h0_meanEffAmplitude')};
        
        obj.pipeline.testing = {
            };
        
        obj.pipeline.validationMethod = {@(method, ratio) obj.crossValidation('Out-of-sample', 0.2)};


    case 'Proposed'

end
end