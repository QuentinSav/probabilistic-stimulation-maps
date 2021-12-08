function grad = util_computeGradientLinearRegression(obj, method)

if strcmpi(method, 'batch')
    
    y = obj.features.regression.y.training;
    X = obj.features.regression.X.training;
    w = obj.features.regression.w;
    m = length(y);
    theta = obj.map.theta;
    
    % Non weighted gradient
    grad = 1/m.*((y - X * theta')' * X);
    
    % Weighted gradient
    %grad = 1/m.*(w'.*(y - PSM.util_sigmoid(X * theta'))' * X);

elseif strcmpi(method, 'stochastic')
    
    y = obj.features.vectorizedScores.training;
    X = obj.features.vectorizedVTAs.training;
    theta = obj.map.theta;
    index = randi(obj.data.training.n, 1);

    grad = (y(index) - X(index, :) * theta')' * X(index, :);

end 

end