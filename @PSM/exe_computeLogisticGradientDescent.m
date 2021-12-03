function exe_computeLogisticGradientDescent(obj)

obj.param.nIteration = 10000;
obj.param.hyperParam.learningRate = 1e-4;

obj.map.theta = zeros(1, size(obj.features.vectorizedVTAs.training, 2));

nDigit = 0;
f1 = figure;
ylabel('training squared error')
xlabel('iterations')
f2 = figure;
ylabel('y')
xlabel('predictions')

for k = 1:obj.param.nIteration
    
    % Progress feedback to user
    if mod(k, 10) == 0 || k == obj.param.nIteration || k == 1
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.param.nIteration);
        
        predictionsTraining = PSM.util_sigmoid(obj.features.vectorizedVTAs.training * obj.map.theta');
        predictionsTesting = PSM.util_sigmoid(obj.features.vectorizedVTAs.testing * obj.map.theta');
        groundTruthTraining = obj.features.vectorizedScores.training;
        groundTruthTesting = obj.features.vectorizedScores.training;
        obj.results.logRegression.trainingError(end+1) = sum((groundTruthTraining - predictionsTraining).^2);
        obj.results.logRegression.testingError(end+1) = sum((groundTruthTesting - predictionsTesting).^2);
        
        set(0, 'CurrentFigure', f1)
        hold off
        plot(obj.results.logRegression.trainingError)
        hold on
        plot(obj.results.logRegression.testingError)
        
        set(0, 'CurrentFigure', f2)
        subplot(1,2,1)
        scatter(predictionsTraining, groundTruthTraining)
        subplot(1,2,2)
        scatter(predictionsTesting, groundTruthTesting)
        hold on
        
        drawnow;
        
    end

    obj.map.theta = obj.map.theta + obj.param.hyperParam.learningRate .* obj.util_computeGradient('stochastic');
    
end
end

