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
        frame
        state
        mode

    end
    
    methods
        function obj = PSM(varargin)
            
            % Add path of python module
            addpath('./py/')
            
            % Set state of object
            obj.state = 'idle';

            % Define expected and default input arguments
            expectedAlgorithm = {
                'Nguyen2019', ...
                'Dembek2019', ...
                'Reich2019', ...
                'Nowacki2022', ...
                'best_ML', ...
                'elastic_net', ...
                'Proposed3',};
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
            obj.data.clinical.table.nVoxel = nan(height(obj.data.clinical.table),1);
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
        R2_kFold = evaluate(obj, metricType);
        preprocess(obj, state);

        % DISPLAY ---------------------------------------------------------
        info(obj); % Not implemented
        showImage(obj, imageToPlot, holdFlag, colorName);
        showResults(obj, resultType);

        % GENERAL UTILITY -------------------------------------------------
        VTA = util_loadVTA(obj, varargin);

    end

    methods (Access = public)

    end
end