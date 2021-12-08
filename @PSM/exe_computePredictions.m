function exe_computePredictions(obj)

fError = findobj( 'Type', 'Figure', 'Name', 'Error');
fPredictions = findobj( 'Type', 'Figure', 'Name', 'Predictions');
fTheta = findobj( 'Type', 'Figure', 'Name', 'Theta');

if isempty(fError)
    fError = figure('Name', 'Error');

end
if isempty(fPredictions)
    fPredictions = figure('Name', 'Predictions');

end
if isempty(fTheta)
    fTheta = figure('Name', 'Theta');

end

predictionsTraining = PSM.util_sigmoid(obj.features.vectorizedVTAs.training * obj.map.theta');
predictionsTesting = PSM.util_sigmoid(obj.features.vectorizedVTAs.testing * obj.map.theta');
groundTruthTraining = obj.features.vectorizedScores.training;
groundTruthTesting = obj.features.vectorizedScores.testing;
obj.results.logRegression.trainingError(end+1) = sum((groundTruthTraining - predictionsTraining).^2);
obj.results.logRegression.testingError(end+1) = sum((groundTruthTesting - predictionsTesting).^2);
theta = obj.map.containerTemplate;
theta.img = reshape(obj.map.theta(2:end), ...
    obj.features.containerSize(1), ...
    obj.features.containerSize(2), ...
    obj.features.containerSize(3));

theta.img = theta.img - min(theta.img, [], 'all');
theta.img = theta.img./max(theta.img, [], 'all');

set(0, 'CurrentFigure', fError)
hold off
plot(obj.results.logRegression.trainingError)
hold on
plot(obj.results.logRegression.testingError)
ylabel('y')
xlabel('predictions')
legend({'training', 'testing'})
set(0, 'CurrentFigure', fPredictions)
subplot(1,2,1)
scatter(predictionsTraining, groundTruthTraining)
ylabel('training squared error')
xlabel('iterations')
subplot(1,2,2)
scatter(predictionsTesting, groundTruthTesting)
ylabel('training squared error')
xlabel('iterations')

set(0, 'CurrentFigure', fTheta)
imshow(squeeze(theta.img(:,:,30)))


drawnow;

end