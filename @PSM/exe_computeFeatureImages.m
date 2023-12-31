function exe_computeFeatureImages(obj, imageTypes, targetImage)
% imageTypes: n, mean, h0_meanEffAmplitude, eArray

disp('--------------------------------------------------');
disp('Computing feature images');

if ~exist("targetImage", "var")
    targetImage.type = 'real';

end

if strcmp(targetImage.type, 'permutation')
    targetFields = {'map', 'permutation', {targetImage.k}};

else
    targetFields = {'map'};

end

if ~isfield(obj.features, "containerSize")
    obj.features.containerSize(1) = inf;
    obj.features.containerSize(2) = inf;
    obj.features.containerSize(3) = inf;

end

% Initialize map

if strcmpi(obj.state, 'training')
    scoresArrayImage = nan([obj.features.containerSize, obj.data.training.n]);
    h0ArrayImage = zeros([obj.features.containerSize, obj.data.training.n]);

elseif strcmpi(obj.state, 'testing')
    scoresArrayImage = nan([obj.features.containerSize, obj.data.testing.n]);
    h0ArrayImage = zeros([obj.features.containerSize, obj.data.testing.n]);
else 
    scoresArrayImage = nan([obj.features.containerSize, obj.data.clinical.n]);
    weightsArrayImage = zeros([obj.features.containerSize, obj.data.clinical.n]);
    h0ArrayImage = zeros([obj.features.containerSize, obj.data.clinical.n]);

end

nDigit = 0;

for k = 1:obj.features.n
    % Progress feedback to user
    if mod(k, 100000) == 0 || k == obj.features.n
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.features.n);
    end

    % Get coordinates of the voxel in integers
    xx = obj.features.coord(k, 1);
    yy = obj.features.coord(k, 2);
    zz = obj.features.coord(k, 3);
    
    if any(strcmp(imageTypes, 'scoresArray'))
        condition = 0 < xx && xx <= obj.features.containerSize(1) && ...
                    0 < yy && yy <= obj.features.containerSize(2) && ...
                    0 < zz && zz <= obj.features.containerSize(3);

        if condition
            scoresArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.scores(k);

        end
    end

    if any(strcmp(imageTypes, 'weightsArray'))
        condition = 0 < xx && xx <= obj.features.containerSize(1) && ...
                    0 < yy && yy <= obj.features.containerSize(2) && ...
                    0 < zz && zz <= obj.features.containerSize(3);
    
        if condition
            weightsArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.weights(k);
            
        end
    end
    
    if any(strcmp(imageTypes, 'permScoresArray'))
        scoresArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.permutedScores(k, targetImage.k);
    end

    if any(strcmp(imageTypes, 'h0MeanScoreSameAmp'))
        % Add the "mean-score"
        h0ArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) =  obj.features.meanScores(k);
    end

end

if any(strcmp(imageTypes, 'n'))

    % Get the container template for the n-image
    fields = [targetFields, {'n'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Get the n image
    nImage = sum(~isnan(scoresArrayImage), 4);

    % Create NIFTI image with the n-image
    fields = [targetFields, {'n', 'img'}];
    obj = setfield(obj, fields{:}, nImage);

end

if any(strcmp(imageTypes, 'mean'))

    % Get the container template for the mean-image
    fields = [targetFields, {'mean'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Get the mean image
    meanImage = mean(scoresArrayImage, 4, 'omitnan');

    % Create NIFTI image with the mean-image
    fields = [targetFields, {'mean', 'img'}];
    obj = setfield(obj, fields{:}, meanImage);

end

if any(strcmp(imageTypes, 'scoresArray')) || any(strcmp(imageTypes, 'permScoresArray'))

    % Get the container template for the mean-image
    fields = [targetFields, {'scoresArray'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Create NIFTI image with the scoresArray-image
    fields = [targetFields, {'scoresArray', 'img'}];
    obj = setfield(obj, fields{:}, scoresArrayImage);

end

if any(strcmp(imageTypes, 'weightsArray'))

    % Get the container template for the mean-image
    fields = [targetFields, {'weigthsArray'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Create NIFTI image with the scoresArray-image
    fields = [targetFields, {'weightsArray', 'img'}];
    obj = setfield(obj, fields{:}, weightsArrayImage);
end

if any(strcmp(imageTypes, 'h0MeanScoreSameAmp'))

    % Get the container template for the h0-image
    fields = [targetFields, {'h0'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Create NIFTI image with the scoresArray-image
    fields = [targetFields, {'h0', 'img'}];
    obj = setfield(obj, fields{:}, h0ArrayImage);

end

if any(strcmp(imageTypes, 'h0ScoresExcludeVox'))

    % Get the container template for the h0-image
    fields = [targetFields, {'h0'}];
    obj = setfield(obj, fields{:}, obj.map.containerTemplate);

    % Creates the h0
    h0Image = repmat(obj.data.training.table.clinicalScore, 1, ...
        obj.features.containerSize(1), ...
        obj.features.containerSize(2), ...
        obj.features.containerSize(3));
    h0Image = permute(h0Image, [2 3 4 1]);
    h0Image(~isnan(scoresArrayImage)) = NaN;

    % Create NIFTI image with the scoresArray-image
    fields = [targetFields, {'h0', 'img'}];
    obj = setfield(obj, fields{:}, h0Image);

end

end