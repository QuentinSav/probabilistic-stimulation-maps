classdef PSM < handle
    % PSM (Probabilistic Stimulation Map object)
    % Requirement: CV toolbox, UAV toolbox, ROS toolbox

    % Detailed explanation goes here
    % TODO finish the litterature review to select around 5 algorithm

    properties

        algorithm
        validationMethod
        hemisphere
        pipeline
        features
        voxelSize
        pThreshold
        nImage
        meanImage
        h0Image
        pImage
        significantMeanImage
        eArrayImage % 4D-image containing all the efficiencies of the voxels (used to speed up p-image computation)
        sweetspot
        clinicalData
        nData
        trainingData
        nTrainingData
        validationData
        nValidationData
        filterImg
        results
        kFold
        state
        alpha
        
        arrayVectVTA

    end

    methods
        function obj = PSM(varargin)

            tmp = struct2cell(load('multicentricTableAllImprovedOnlyRev04.mat'));
            
            % Define expected and default input arguments
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

        set_filter(obj, method);
        compute_featureImages(obj, method, images);
        compute_pImage(obj, statTest, h0);
        compute_significantpImage(obj);
        hPartition = crossValidation(obj, method, KFold);

    end

    methods (Static)
        
        voxsize = get_voxelSize(transform);
        newCoordinates = transform(oldCoordinates, image, direction)
        
    end
end