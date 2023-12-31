function overfitFlag = exe_computePredictions(obj, type, it)

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
    fTheta = figure('Name', 'Theta', 'Position', [675,660,908,302]);

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

obj.results.regression.trainingError(end+1) = mean((groundTruthTraining - obj.results.regression.predictionsTraining).^2);
obj.results.regression.testingError(end+1) = mean((groundTruthTesting - obj.results.regression.predictionsTesting).^2);
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

% theta.img = theta.img - min(theta.img, [], 'all');
% theta.img = theta.img./max(theta.img, [], 'all');

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

absMax = max(abs(theta.img(:,:,8)), [], 'all');
boundColMap = [-absMax absMax];
if absMax == 0
    boundColMap = [-1 1];
end
subplot(1, 2, 1);
imagesc(squeeze(theta.img(:,:,8)), boundColMap); 
colMap = colMapGen([1 0.1 0.1], [0.1 0.1 1], 100, 'midCol',[1 1 1]);
colormap(colMap)
axis off
axis square
colorbar
% title(['iteration #', num2str(it)])
subplot(1, 2, 2);
scatter(obj.results.regression.predictionsTraining, groundTruthTraining, 8, 'filled')
hold on
plot(linspace(0,1,2), linspace(0,1,2),'k--')
hold off

axis square
axis([0 1 0 1])
ylabel('Efficiency (Ground Truth)')
xlabel('Prediction')
%obj.frame(end + 1) = getframe(fTheta);
%imshow(squeeze(theta.img(:,:,30)), 'InitialMagnification','fit')

drawnow;

end