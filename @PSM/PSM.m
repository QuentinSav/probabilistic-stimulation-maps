classdef PSM < handle
    % PSM Class 
    % (Probabilistic Stimulation Map) 
    % 
    % This class allows to handle a probilistic stimulation map instance.
    % The input arguments for the 
    %
    % Requirement: CV toolbox, UAV toolbox, ROS toolbox
    
    % TODO: 
    %       - Modify check_voxsize to check_voxSize
    %       - Modify crossValidation to set_validationMethod
    %       - Finish compute_pImage: add Reich test(to be checked)
    
    properties
        
        % Input properties
        algorithm
        hemisphere
        
        % Data
        clinicalData
        nData
        trainingData
        nTrainingData
        validationData
        nValidationData
        
        % Parameters
        filterImg
        pipeline
        validationMethod
        features
        voxelSize
        alpha = 0.05
        pThreshold

        % Output properties
        nImage
        meanImage
        h0Image
        pImage
        tImage
        significantMeanImage
        eArrayImage 
        sweetspot
        results
        
        % State
        kFold
        state = 'idle'

    end

    methods
        function obj = PSM(varargin)
            
            % Define expected and default input arguments
            tmp = struct2cell(load('multicentricTableAllImprovedOnlyRev04.mat'));
            defaultData = tmp{1};
            expectedAlgorithm = {
                'Nguyen, 2019', ...
                'Dembek, 2019', ...
                'Reich, 2019', ...
                'Proposed'};
            defaultAlgorithm = 'Nguyen, 2019';
            expectedHemiphere = {
                'Both', ...
                'Right', ...
                'Left'};
            defaultHemisphere = 'Both';
            
            % Create parser
            p = inputParser();
            addOptional(p,'data', defaultData, @istable);
            addParameter(p, 'algorithm', defaultAlgorithm, ...
                @(x) any(validatestring(x, expectedAlgorithm)));
            addParameter(p, 'hemisphere', defaultHemisphere,...
                @(x) any(validatestring(x, expectedHemiphere)));
            parse(p, varargin{:});
            
            % Assign input arguments to object properties
            obj.algorithm = p.Results.algorithm;
            obj.hemisphere = p.Results.hemisphere;
            obj.clinicalData = p.Results.data;

            % Keep the correct hemispheric data
            obj.filter_data();
            obj.nData = height(obj.clinicalData);

            % Create the pipeline (list of function that will be executed)
            obj.create_pipeline();
            
        end
        
        status = check_voxsize(obj);
        compute_featureImages(obj, imageTypes);
        compute_map(obj);
        pImage = compute_pImage(obj, statTestType, h0Type);
        compute_significantMeanImage(obj);
        create_pipeline(obj);
        hPartition = crossValidation(obj, method, varargin);
        filter_data(obj);
        get_features(obj, features);
        get_matVectVTA(obj);
        VTA = loadVTA(obj, varargin);
        voxelArray = nii2voxelArray(obj, image, type, outputSpace);
        set_filter(obj, method);
        showImage(obj, imageToPlot, holdFlag, colorName);
        showResults(obj, resultType);
        test(obj);
        threshold(obj, thresholdValue);
        train(obj);
        type1ErrorCorrection(obj, method);

    end

    methods (Static)
        
        voxsize = get_voxelSize(transform);
        newCoordinates = transform(oldCoordinates, image, direction);
        
    end
end