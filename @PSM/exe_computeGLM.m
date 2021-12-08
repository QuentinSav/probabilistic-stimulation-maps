function exe_computeGLM(obj)
y = obj.features.logRegression.y.training;
X = obj.features.logRegression.X.training;
obj.map.theta = glmfit(X, y, 'poisson');

end