function grad = util_computeGradient(obj, method)

if strcmpi(method, 'batch')
    
    y = obj.features.vectorizedScores.training;
    X = obj.features.vectorizedVTAs.training;
    m = length(y);
    theta = obj.map.theta;

    grad = 1/m*((y - PSM.util_sigmoid(X * theta'))' * X);

elseif strcmpi(method, 'stochastic')
    
    y = obj.features.vectorizedScores.training;
    X = obj.features.vectorizedVTAs.training;
    theta = obj.map.theta;
    index = randi(obj.data.training.n, 1);

    grad = (y(index) - PSM.util_sigmoid(X(index, :) * theta'))' * X(index, :);

end 

end