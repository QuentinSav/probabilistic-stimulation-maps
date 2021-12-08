function exe_computeLogisticGradientDescent(obj)

obj.param.nIteration = 10000;
obj.param.hyperParam.learningRate = 1e-3;

obj.map.theta = zeros(1, size(obj.features.vectorizedVTAs.training, 2));

nDigit = 0;

for k = 1:obj.param.nIteration
    
    % Progress feedback to user
    if mod(k, 10) == 0 || k == obj.param.nIteration || k == 1
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.param.nIteration);

        obj.test();
        
    end

    obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* obj.util_computeGradient('batch');
    
end
end

