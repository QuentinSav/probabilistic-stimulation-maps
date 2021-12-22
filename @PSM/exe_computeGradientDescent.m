function exe_computeGradientDescent(obj, type, regularization)

if strcmpi(regularization, 'none')
    
    obj.param.nIteration = 100000;
    obj.param.hyperParam.learningRate = 5e-3;
    obj.param.hyperParam.lambda = 0;
    if strcmpi(type, 'linear')
        computeGradient = @(type) obj.util_computeGradientLinearRegression('batch');

    elseif strcmpi(type, 'logistic')
        computeGradient = @(type) obj.util_computeGradientLogisiticRegression('batch');
    
    end

elseif strcmpi(regularization, 'l1')
    
    obj.param.nIteration = 1;
    
    if strcmpi(type, 'linear')
        computeGradient = @(type) obj.util_computeGradientLinearRegression('batch');

    elseif strcmpi(type, 'logistic')
        
        obj.map.theta = zeros(1, size(obj.features.regression.X.training, 2));
        [obj.map.theta, FitInfo] = lassoglm(obj.features.regression.X.training, ...
            obj.features.regression.y.training, ...
            'binomial', ...
            'NumLambda', 2, ...
            'CV', 5, ...
            'MaxIter', 1e3, ...
            'Options',statset('UseParallel',true));
        
        obj.map.theta = obj.map.theta';

        return
    end

elseif strcmpi(regularization, 'l2')

end

obj.param.nIteration = 100000;
obj.param.hyperParam.learningRate = 5e-3;

obj.map.theta = zeros(1, size(obj.features.regression.X.training, 2));

nDigit = 0;

obj.frame(1).cdata = [];
obj.frame(1).colormap = [];

for k = 1:obj.param.nIteration
    
    % Progress feedback to user
    if mod(k, 10) == 0 || k == obj.param.nIteration || k == 1
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.param.nIteration);

        overfitFlag = obj.exe_computePredictions(type, k);
        
        if overfitFlag && overfitFlagPrevious 
            break;
        end
        
        overfitFlagPrevious = overfitFlag;

    end
    
    % Not regularized
    %obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* computeGradient();
    
    % l2-regularization
    obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* computeGradient() - 2*obj.param.hyperParam.lambda.*obj.map.theta;
    
end
end

