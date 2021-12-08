function overfitFlag = exe_computePredictions(obj, type)

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

if strcmpi(type, 'linear')
    obj.results.regression.predictionsTraining = obj.features.regression.X.training * obj.map.theta';
    obj.results.regression.predictionsTesting = obj.features.regression.X.testing * obj.map.theta';

elseif strcmpi(type, 'logistic')
    obj.results.regression.predictionsTraining = PSM.util_sigmoid(obj.features.regression.X.training * obj.map.theta');
    obj.results.regression.predictionsTesting = PSM.util_sigmoid(obj.features.regression.X.testing * obj.map.theta');

end

groundTruthTraining = obj.features.regression.y.training;
groundTruthTesting = obj.features.regression.y.testing;

obj.results.regression.trainingError(end+1) = sum((groundTruthTraining - obj.results.regression.predictionsTraining).^2);
obj.results.regression.testingError(end+1) = sum((groundTruthTesting - obj.results.regression.predictionsTesting).^2);
obj.results.score = groundTruthTesting;

if length(obj.results.regression.testingError) > 1
    overfitFlag = obj.results.regression.testingError(end) > obj.results.regression.testingError(end-1);
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
plot(obj.results.regression.trainingError)
hold on
plot(obj.results.regression.testingError)
ylabel('y')
xlabel('predictions')
legend({'training', 'testing'})
set(0, 'CurrentFigure', fPredictions)
subplot(1,2,1)
scatter(obj.results.regression.predictionsTraining, groundTruthTraining)
ylabel('training squared error')
xlabel('iterations')
subplot(1,2,2)
scatter(obj.results.regression.predictionsTesting, groundTruthTesting)
ylabel('training squared error')
xlabel('iterations')

set(0, 'CurrentFigure', fTheta)
imshow(squeeze(theta.img(:,:,30)), 'InitialMagnification','fit')


drawnow;

end