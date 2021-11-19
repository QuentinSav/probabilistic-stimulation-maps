classdef PSM < handle
    % PSM Class 
    % (Probabilistic Stimulation Map) 
    % 
    % This class allows to handle a probilistic stimulation map instance.
    % Input arguments (required):
    %   - Data table with minimum required fields: 
    %           clinical score, 
    % 
    % The map computation can be performed in 2 different modes:
    %   - Standard: computes the map on 95% of the dataset
    %   - Analysis: perform multiple maps and perform cross-validation. 
    %
    % The user can also specify
    properties (Access = public)
        
        information
        map

    end

    properties (Access = private)
    
        % Input properties
        algorithm
        pipeline 
        
        % Data
        data.properties.hemisphere
        data.properties.

        data.clinical.table
        data.clinical.n

        data.training.table
        data.testing.table

        data.training.n
        data.testing.n
        
        % General parameters
        param.filterImg
        param.voxelSize
        param.alpha = 0.05
        param.pThreshold

        % Output properties
%         map.features
%         map.n
%         map.mean
%         map.h0
%         map.p
%         map.t
%         map.significantMeanImage
%         map.eArray
%         map.sweetspot
        
        results
        
        % Object state
        state
        mode

    end

    methods
        function obj = PSM(varargin)
            
            obj.state = 'idle';
            
            % Define expected and default input arguments
            expectedAlgorithm = {
                'Nguyen, 2019', ...
                'Dembek, 2019', ...
                'Reich, 2019', ...
                'Proposed'};
            defaultAlgorithm = 'Nguyen, 2019';
            expectedHemiphere = {
                '', ...
                'Both', ...
                'Right', ...
                'Left'};
            defaultHemisphere = '';
            expectedMode = {
                'Standard', ...
                'Analysis'};
            defaultMode = 'Standard';

            % Create parser
            p = inputParser();
            addRequired(p,'data', @istable);
            addParameter(p, 'algorithm', defaultAlgorithm, ...
                @(x) any(validatestring(x, expectedAlgorithm)));
            addParameter(p, 'hemisphere', defaultHemisphere,...
                @(x) any(validatestring(x, expectedHemiphere)));
            addParameter(p, 'mode', defaultMode,...
                @(x) any(validatestring(x, expectedMode)));
            parse(p, varargin{:});
            
            % Assign input arguments to object properties
            obj.data.clinical = p.Results.data;
            obj.algorithm = p.Results.algorithm;
            obj.data.hemisphere = p.Results.hemisphere;
            obj.mode = p.Results.mode;
            
            % Keep the correct hemispheric data
            obj.filter_data();
            obj.data.clinical.n = height(obj.clinicalData);

            % Create the pipeline (list of function that will be executed)
            obj.create_pipeline();
            
        end
        
        status = check_voxsize(obj);
        compute_featureImages(obj, imageTypes);
        compute_map(obj);
        pImage = compute_pImage(obj, statTestType, h0Type);
        compute_significantMeanImage(obj);
        
        hPartition = crossValidation(obj, method, varargin);
        filter_data(obj);

        get_matVectVTA(obj);
        VTA = loadVTA(obj, varargin);
        voxelArray = nii2voxelArray(obj, image, type, outputSpace);
        
        showImage(obj, imageToPlot, holdFlag, colorName);
        showResults(obj, resultType);

        
        % SETUP -----------------------------------------------------------
        create_pipeline(obj);

        % TRAINING (map generation) ---------------------------------------
        train(obj); % High-level function
        
        % Low-level function
        set_filter(obj, method);
        threshold(obj, thresholdValue);
        type1ErrorCorrection(obj, method);
        get_features(obj, features);

        % TESTING ---------------------------------------------------------
        test(obj); % High-level function
        
        % Low level function
        
        % DISPLAY ---------------------------------------------------------
    
        % GENERAL USE -----------------------------------------------------
    
    end

    methods (Static)
        
        voxsize = get_voxelSize(transform);
        newCoordinates = transform(oldCoordinates, image, direction);
        
    end
end