function grad = util_computeGradientLogisiticRegression(obj, method)

if strcmpi(method, 'batch')
    
    y = obj.features.regression.y.training;
    X = obj.features.regression.X.training;
    
    m = length(y);
    theta = obj.map.theta;
    
    % Non weighted gradient
    grad = 1/m.*((y - PSM.util_sigmoid(X * theta'))' * X);
    
    % Weighted gradient
    %w = obj.features.regression.w;
    %grad = 1/m.*(w'.*(y - PSM.util_sigmoid(X * theta'))' * X);

elseif strcmpi(method, 'stochastic')
    
    y = obj.features.regression.y.training;
    X = obj.features.regression.X.training;
    theta = obj.map.theta;
    index = randi(obj.data.training.n, 1);

    grad = (y(index) - PSM.util_sigmoid(X(index, :) * theta'))' * X(index, :);

end 

end