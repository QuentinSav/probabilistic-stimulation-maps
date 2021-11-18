function compute_featureImages(obj, imageTypes)
    % imageTypes: n, mean, h0_meanEffAmplitude, eArray

disp('--------------------------------------------------');
disp('Computing feature images');

% Initialize map
nImage = zeros(obj.features.coordSize);
sumImage = zeros(obj.features.coordSize);
h0Image = zeros(obj.features.coordSize);
h0sumImage = zeros(obj.features.coordSize);
eArrayImage = NaN([obj.features.coordSize, obj.nTrainingData]);

nDigit = 0;

for k = 1:obj.features.n
    % TODO avoid if within the loop by using function handles
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
        sumImage(xx, yy, zz) = sumImage(xx, yy, zz) + obj.features.efficiencies(k);
    end

    if any(strcmp(imageTypes, 'h0_meanEffAmplitude'))
        % Add the "mean-efficiency"
        h0sumImage(xx, yy, zz) = sumImage(xx, yy, zz) + obj.features.meanEfficiencies(k);
    end

    if any(strcmp(imageTypes, 'eArray'))
        eArrayImage(xx, yy, zz, obj.features.indexVTAs(k)) = obj.features.efficiencies(k);
    end

end

if any(strcmp(imageTypes, 'n'))
    % Create NIFTI image with the mean-image
    obj.nImage = ea_make_nii(nImage, obj.voxelSize, - obj.features.coordOffset);
    obj.nImage.mat = diag([obj.voxelSize, 1]);
    obj.nImage.mat(1:3, 4) = obj.features.coordOffset.*obj.voxelSize;

end

if any(strcmp(imageTypes, 'mean'))
    % Compute the mean from the sum of clinical efficiencies
    meanImage = sumImage./obj.nImage.img;
    meanImage(isinf(meanImage)) = 0;

    % Create NIFTI image with the mean-image
    obj.meanImage = ea_make_nii(meanImage, obj.voxelSize, - obj.features.coordOffset);
    obj.meanImage.mat = diag([obj.voxelSize, 1]);
    obj.meanImage.mat(1:3, 4) = obj.features.coordOffset.*obj.voxelSize;

end

if any(strcmp(imageTypes, 'h0_meanEffAmplitude'))
    % Compute the mean from the sum of clinical efficiencies
    h0sumImage = h0sumImage./obj.nImage.img;
    h0Image(isinf(h0sumImage)) = 0;

    % Create NIFTI image with the mean-image
    obj.h0Image = ea_make_nii(h0Image, obj.voxelSize, - obj.features.coordOffset);
    obj.h0Image.mat = diag([obj.voxelSize, 1]);
    obj.h0Image.mat(1:3, 4) = obj.features.coordOffset.*obj.voxelSize;

end

if any(strcmp(imageTypes, 'eArray'))
    % Efficacies array image
    obj.eArrayImage = eArrayImage;
    
end
end