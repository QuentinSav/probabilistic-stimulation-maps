function exe_computeFeatureImages(obj, imageTypes)
% imageTypes: n, mean, h0_meanEffAmplitude, eArray

disp('--------------------------------------------------');
disp('Computing feature images');

% Initialize map
h0sumImage = zeros(obj.features.containerSize);
scoresArrayImage = nan([obj.features.containerSize, obj.data.training.n]);

nDigit = 0;

for k = 1:obj.features.n
    %
    if mod(k, 100000) == 0 || k == obj.features.n
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Feature # %d / %d\n', k, obj.features.n);
    end

    % Get coordinates of the voxel in integers
    xx = obj.features.coord(k, 1);
    yy = obj.features.coord(k, 2);
    zz = obj.features.coord(k, 3);

    if any(strcmp(imageTypes, 'scoresArray'))
        scoresArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.scores(k);
    end

    if any(strcmp(imageTypes, 'h0MeanScoresSameAmp'))
        % Add the "mean-efficiency"
        h0sumImage(xx, yy, zz) = h0sumImage(xx, yy, zz) + obj.features.meanScores(k);
    end

end

if any(strcmp(imageTypes, 'n'))

    % Get the container template for the n-image
    obj.map.n = obj.map.containerTemplate;

    % Create NIFTI image with the n-image
    obj.map.n.img = sum(~isnan(scoresArrayImage), 4);

end

if any(strcmp(imageTypes, 'mean'))

    % Get the container template for the mean-image
    obj.map.mean = obj.map.containerTemplate;

    % Create NIFTI image with the mean-image
    obj.map.mean.img = mean(scoresArrayImage, 4, 'omitnan');

end

if any(strcmp(imageTypes, 'scoresArray'))

    % Get the container template for the mean-image
    obj.map.scoresArray = obj.map.containerTemplate;

    % Efficacies array image
    obj.map.scoresArray.img = scoresArrayImage;

end

if any(strcmp(imageTypes, 'h0MeanScoreSameAmp'))

    % Get the container template for the h0-image
    obj.map.h0 = obj.map.containerTemplate;

    % Compute the mean from the sum of clinical efficiencies
    obj.map.h0.img = h0sumImage./obj.map.n.img;
    obj.map.h0.img(isinf(h0sumImage)) = NaN;

end

if any(strcmp(imageTypes, 'h0ScoresExcludeVox'))

    % Get the container template for the h0-image
    obj.map.h0 = obj.map.containerTemplate;

    % Creates the h0
    obj.map.h0.img = repmat(obj.data.training.table.clinicalScore, 1, ...
        obj.features.containerSize(1), ...
        obj.features.containerSize(2), ...
        obj.features.containerSize(3));
    obj.map.h0.img = permute(obj.map.h0.img, [2 3 4 1]);
    obj.map.h0.img(~isnan(scoresArrayImage)) = NaN;

end

if any(strcmp(imageTypes, 'permutation'))
    obj.util_computePermutationImages();
    
end

end