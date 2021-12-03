function grad = util_computeGradient(obj, method)

if strcmpi(method, 'batch')
    
    y = obj.features.vectorizedScores.training;
    X = obj.features.vectorizedVTAs.training;
    theta = obj.map.theta;

    grad = ((y - PSM.util_sigmoid(X * theta'))' * X);

elseif strcmpi(method, 'stochastic')
    
    y = obj.features.vectorizedScores;
    X = obj.features.vectorizedVTAs;
    theta = obj.map.theta;

    grad = (y - PSM.util_sigmoid(X(randi(obj.data.training.n), :) * theta'))' * X(randi(obj.data.training.n), :);

end 

end