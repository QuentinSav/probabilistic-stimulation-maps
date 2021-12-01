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
    % The user can also specify the hemisphere, the leadID, the center, the
    % threshold for sweetspot computation

    properties (Access = public)
        
        algorithm
        pipeline  
        map
        results
        features
        data
        param

    end

    properties (Access = private) 
    
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
                'Dembek2019', ...
                'Reich2019', ...
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
            defaultBypassCheck = false;

            % Create parser
            p = inputParser();

            % Add required argument
            addRequired(p,'data', @istable);
            
            % Add optional parameters
            addParameter(p, 'algorithm', defaultAlgorithm, ...
                @(x) any(validatestring(x, expectedAlgorithm)));
            addParameter(p, 'hemisphere', defaultHemisphere,...
                @(x) any(validatestring(x, expectedHemiphere)));
            addParameter(p, 'centerID', 0,...
                @(x) ~mod(x, 1));
            addParameter(p, 'mode', defaultMode,...
                @(x) any(validatestring(x, expectedMode)));
            addParameter(p, 'bypassCheck', defaultBypassCheck,...
                @(x) islogical(x));
            parse(p, varargin{:});
            
            % Assign input arguments to object properties
            obj.data.clinical.table = p.Results.data;
            obj.data.screen.hemisphere = p.Results.hemisphere; 
            obj.data.screen.centerID = p.Results.centerID;
            obj.algorithm = p.Results.algorithm;
            obj.mode = p.Results.mode;
            bypassCheck = p.Results.bypassCheck;
            
            % Create the pipeline (list of function that will be executed)
            obj.util_createPipeline();

            % Keep the correct hemispheric data
            obj.util_dataScreening();
            obj.data.clinical.n = height(obj.data.clinical.table);
            
            if ~bypassCheck
                obj.util_checkBatch();
            
            end
        end
        
        % GENERAL ---------------------------------------------------------
        compute(obj);
        evaluate(obj);

        % DISPLAY ---------------------------------------------------------
        info(obj); % Not implemented
        showImage(obj, imageToPlot, holdFlag, colorName);
        showResults(obj, resultType);

    end

    methods (Access = private)
        
        % SETUP -----------------------------------------------------------
        util_createPipeline(obj);      
        util_screenData(obj);
        hPartition = util_getValidPartition(obj, method, varargin);
        status = util_checkVoxelSize(obj);
        
        % TRAINING (map generation) ---------------------------------------
        train(obj); % High-level function
        
        % Low-level function
        util_setFilter(obj, method);
        exe_compileFeatures(obj, features, nPermutationImages);
        exe_computeFeatureImages(obj, imageTypes, targetImage);
        exe_thresholdImages(obj);
        exe_computeStatTests(obj, statTestType, h0Type, targetImage);
        exe_computeFalsePosCorrection(obj, method);
        exe_computeSignMeanImage(obj);
        exe_computePermutationImages(obj);
        exe_computeSweetSpot(obj, method);
        
        meanScoresFeatures = util_getMeanScoreSameAmplitude(obj)
        activatedVoxels = util_getActivatedVoxels(obj);
        util_matVectVTA(obj); % for proposed pipeline
        permutedScores = util_computePermutedScores(obj, nPermutationImages);
        Q = util_getSummaryStat(obj, pImage);

        % TESTING ---------------------------------------------------------
        test(obj); % High-level function
        
        % Low level function
        exe_computeOverlap(obj)

        % GENERAL UTILITY -------------------------------------------------
        VTA = util_loadVTA(obj, varargin);

    end
    
    methods (Static)
        
        % GENERAL UTILITY -------------------------------------------------
        voxsize = util_getVoxelSize(transform);
        newCoordinates = util_transform(oldCoordinates, image, direction);
        voxelArray = util_nii2voxelArray(image, type, outputSpace);

    end
end