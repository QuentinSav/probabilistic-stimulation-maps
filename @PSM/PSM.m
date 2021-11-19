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
        
        map
        results

    end

    properties (Access = public) % TODO make it private
    
        % Input properties
        algorithm
        pipeline 
        
        % Data
        data
        
        % General parameters
        param

        % Object state
        state
        mode

    end

    methods
        function obj = PSM(varargin)
            
            obj.state = 'idle';
            
            % Define expected and default input arguments
            expectedAlgorithm = {
                'Nguyen2019', ...
                'DembekRoediger2019', ...
                'ReichHorn2019', ...
                'Proposed'};
            defaultAlgorithm = 'Nguyen2019';
            expectedHemiphere = {
                '', ...
                'both', ...
                'right', ...
                'left'};
            defaultHemisphere = '';
            expectedMode = {
                'standard', ...
                'analysis'};
            defaultMode = 'standard';

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
            obj.data.clinical.table = p.Results.data;
            obj.data.clinical.n = height(obj.data.clinical.table);
           
            obj.data.screen.hemisphere = p.Results.hemisphere; 
    
            obj.algorithm = p.Results.algorithm;
            obj.mode = p.Results.mode;
            
            % Keep the correct hemispheric data
            obj.screen_data();

            % Create the pipeline (list of function that will be executed)
            obj.create_pipeline();
            
        end
        
        screen_data(obj);

        compute_featureImages(obj, imageTypes);
        compute_map(obj);
        pImage = compute_pImage(obj, statTestType, h0Type);
        compute_significantMeanImage(obj);
        
        
        % SETUP -----------------------------------------------------------
        create_pipeline(obj);        
        hPartition = crossValidation(obj, method, varargin);
        
        status = check_voxSize(obj);
        
        % TRAINING (map generation) ---------------------------------------
        train(obj); % High-level function
        
        % Low-level function
        set_filter(obj, method);
        get_features(obj, features);
        threshold(obj, thresholdValue);
        type1ErrorCorrection(obj, method);
        
        get_matVectVTA(obj); % for proposed pipeline
        
        % TESTING ---------------------------------------------------------
        test(obj); % High-level function
        
        % Low level function
        
        % DISPLAY ---------------------------------------------------------
        information(obj);
        showImage(obj, imageToPlot, holdFlag, colorName);
        showResults(obj, resultType);

        % GENERAL USE -----------------------------------------------------
        VTA = loadVTA(obj, varargin);
        voxelArray = nii2voxelArray(obj, image, type, outputSpace);
    
    end

    methods (Static)
        
        voxsize = get_voxelSize(transform);
        newCoordinates = transform(oldCoordinates, image, direction);
        
    end
end