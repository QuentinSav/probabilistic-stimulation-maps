function exe_computeGradientDescent(obj, type)

if strcmpi(type, 'linear')
    computeGradient = @(type) obj.util_computeGradientLinearRegression('batch');

elseif strcmpi(type, 'logistic')
    computeGradient = @(type) obj.util_computeGradientLogisiticRegression('batch');

end

obj.param.nIteration = 2000;
obj.param.hyperParam.learningRate = 1e-4;

obj.map.theta = zeros(1, size(obj.features.regression.X.training, 2));

nDigit = 0;

for k = 1:obj.param.nIteration
    
    % Progress feedback to user
    if mod(k, 10) == 0 || k == obj.param.nIteration || k == 1
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.param.nIteration);

        overfitFlag = obj.exe_computePredictions(type);
        
        if overfitFlag && overfitFlagPrevious 
            %break;
        end
        
        overfitFlagPrevious = overfitFlag;

    end

    obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* computeGradient();
    
end
end

