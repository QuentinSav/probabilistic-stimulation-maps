function exe_computeFeatureImages(obj, imageTypes)
    % imageTypes: n, mean, h0_meanEffAmplitude, eArray

disp('--------------------------------------------------');
disp('Computing feature images');

% Initialize map
nImage = zeros(obj.features.containerSize);
sumImage = zeros(obj.features.containerSize);
h0Image = zeros(obj.features.containerSize);
h0sumImage = zeros(obj.features.containerSize);
eArrayImage = NaN([obj.features.containerSize, obj.data.training.n]);

nDigit = 0;

for k = 1:obj.features.n
    % 
    if mod(k, 100000) == 0 || k == obj.features.n
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('mean-image: Processing feature # %d / %d\n', k, obj.features.n);
    end
    
    % Get coordinates of the voxel in integers
    xx = obj.features.coord(k, 1);
    yy = obj.features.coord(k, 2);
    zz = obj.features.coord(k, 3);
    
    if any(strcmp(imageTypes, 'n'))
        % Add the weigth of the voxel to the n-image
        nImage(xx, yy, zz) = nImage(xx, yy, zz) + obj.features.weights(k);
    end

    if any(strcmp(imageTypes, 'mean'))
        % Add the efficiency of the voxel to the sum-image
        sumImage(xx, yy, zz) = sumImage(xx, yy, zz) + obj.features.scores(k);
    end

    if any(strcmp(imageTypes, 'h0_meanEffAmplitude'))
        % Add the "mean-efficiency"
        h0sumImage(xx, yy, zz) = sumImage(xx, yy, zz) + obj.features.meanScores(k);
    end

    if any(strcmp(imageTypes, 'scoresArray'))
        scoresArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.scores(k);
    end

end

if any(strcmp(imageTypes, 'n'))
    % Create NIFTI image with the mean-image
    obj.map.n = ea_make_nii(nImage, obj.features.voxelSize, - obj.features.containerOffset);
    obj.map.n.mat = diag([obj.features.voxelSize, 1]);
    obj.map.n.mat(1:3, 4) = obj.features.containerOffset.*obj.features.voxelSize;

end

if any(strcmp(imageTypes, 'mean'))
    % Compute the mean from the sum of clinical efficiencies
    meanImage = sumImage./obj.map.n.img;
    meanImage(isinf(meanImage)) = 0;

    % Create NIFTI image with the mean-image
    obj.map.mean = ea_make_nii(meanImage, obj.features.voxelSize, - obj.features.containerOffset);
    obj.map.mean.mat = diag([obj.features.voxelSize, 1]);
    obj.map.mean.mat(1:3, 4) = obj.features.containerOffset.*obj.features.voxelSize;

end

if any(strcmp(imageTypes, 'h0_meanScoreAmplitude'))
    % Compute the mean from the sum of clinical efficiencies
    h0sumImage = h0sumImage./obj.map.n.img;
    h0Image(isinf(h0sumImage)) = 0;

    % Create NIFTI image with the mean-image
    obj.map.h0 = ea_make_nii(h0Image, obj.features.voxelSize, - obj.features.containerOffset);
    obj.h0Image.mat = diag([obj.features.voxelSize, 1]);
    obj.h0Image.mat(1:3, 4) = obj.features.containerOffset.*obj.features.voxelSize;

end

if any(strcmp(imageTypes, 'h0_scoresExcludeVox'))
    
    h0Image = repmat(obj.data.training.table.clinicalScore, 1, obj.features.containerSize(1), obj.features.containerSize(2),obj.features.containerSize(3));
    h0Image = permute(h0Image, [2 3 4 1]);
    
    h0Image(~isnan(eArrayImage)) = NaN;
    
    obj.h0Image = h0Image;
    
end

if any(strcmp(imageTypes, 'scoresArray'))
    % Efficacies array image
    obj.map.scoresArray = scoresArrayImage;
    
end
end