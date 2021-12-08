function exe_computeGradientDescent(obj, type)

obj.param.nIteration = 2000;
obj.param.hyperParam.learningRate = 1e-3;

obj.map.theta = zeros(1, size(obj.features.logRegression.X.training, 2));

nDigit = 0;

for k = 1:obj.param.nIteration
    
    % Progress feedback to user
    if mod(k, 10) == 0 || k == obj.param.nIteration || k == 1
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.param.nIteration);

        overfitFlag = obj.exe_computePredictions('linear');
        
        if overfitFlag && overfitFlagPrevious 
            break;
        end
        
        overfitFlagPrevious = overfitFlag;

    end

    obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* obj.util_computeGradientLogisticRegression('batch');
    
end
end

