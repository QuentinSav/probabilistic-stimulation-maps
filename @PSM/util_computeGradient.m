function grad = util_computeGradient(obj, method)

if strcmpi(method, 'batch')
    
    y = obj.features.vectorizedScores;
    X = obj.features.vectorizedVTAs;
    theta = obj.map.theta;

    grad = ((y - PSM.util_sigmoid(X * theta'))' * X);

elseif strcmpi(method, 'stochastic')


end 

end