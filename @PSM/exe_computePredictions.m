function overfitFlag = exe_computePredictions(obj)

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

obj.results.logRegression.predictionsTraining = PSM.util_sigmoid(obj.features.logRegression.X.training * obj.map.theta');
obj.results.logRegression.predictionsTesting = PSM.util_sigmoid(obj.features.logRegression.X.testing * obj.map.theta');
groundTruthTraining = obj.features.logRegression.y.training;
groundTruthTesting = obj.features.logRegression.y.testing;
obj.results.logRegression.trainingError(end+1) = sum((groundTruthTraining - obj.results.logRegression.predictionsTraining).^2);
obj.results.logRegression.testingError(end+1) = sum((groundTruthTesting - obj.results.logRegression.predictionsTesting).^2);
obj.results.score = groundTruthTesting;
if length(obj.results.logRegression.testingError) > 1
    overfitFlag = obj.results.logRegression.testingError(end) > obj.results.logRegression.testingError(end-1);
else
    overfitFlag = 0;

end
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
scatter(obj.results.logRegression.predictionsTraining, groundTruthTraining)
ylabel('training squared error')
xlabel('iterations')
subplot(1,2,2)
scatter(obj.results.logRegression.predictionsTesting, groundTruthTesting)
ylabel('training squared error')
xlabel('iterations')

set(0, 'CurrentFigure', fTheta)
imshow(squeeze(theta.img(:,:,30)), 'InitialMagnification','fit')


drawnow;

end