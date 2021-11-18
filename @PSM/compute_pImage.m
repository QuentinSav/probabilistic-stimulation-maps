function pImage = compute_pImage(obj, statTestType, h0Type)

disp('--------------------------------------------------');
disp('Computing p-image');

% Initial
pImage = NaN(obj.features.coordSize);

% Define the null hypothesis
if strcmpi(h0Type, 'zero')
    get_h0 = @(voxel) 0;

elseif strcmpi(h0Type, 'h0_meanEffAmplitude')
    get_h0 = @(voxel) obj.h0Image.img(voxel(1), voxel(2), voxel(3));

elseif strcmpi(h0Type, 'meanEffExcludeVox')
    get_h0 = @(voxel) obj.h0Image.img(voxel(1), voxel(2), voxel(3));

end

% Define the  voxel-wise statistical test
if strcmpi(statTestType, 'exactWilcoxon')
    statTest = @(xx, yy, zz, h0) signrank(squeeze(obj.eArrayImage(xx, yy, zz, :)), ...
        h0, 'tail', 'right', 'method', 'exact');

elseif strcmpi(statTestType, 'approxWilcoxon')
    statTest = @(xx, yy, zz, h0) signrank(squeeze(obj.eArrayImage(xx, yy, zz, :)), ...
        h0, 'tail', 'right', 'method', 'approximate');

elseif strcmpi(statTestType, 't-test')
    statTest = @(xx, yy, zz, h0) ttest2(squeeze(obj.eArrayImage(xx, yy, zz, :)), ...
        h0);

end

% Get the voxel to be tested in the n-Image
voxels = obj.nii2voxelArray(obj.nImage, 'array', 'voxel');

k = 1;
nDigit = 0;

for voxel = voxels.coord'
    
    % Progress feedback to the user
    if mod(k, 1000) == 0 || k == length(voxels.coord)
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Processing voxel # %d / %d\n', k, length(voxels.coord));

    end
    
    % Get coordinates of the voxel in integers
    xx = voxel(1);
    yy = voxel(2);
    zz = voxel(3);
    
    % Get the null-hypothesis
    h0 = get_h0(voxel);
    
    % Compute the p-value of the statistical test
    pImage(xx, yy, zz) = statTest(xx, yy, zz, h0);
    
    k = k + 1;

end

if strcmpi(statTestType, 't-test')
    

    

else
    % Assign the property pImage
    obj.pImage.mat = obj.nImage.mat;
    obj.pImage.img = pImage;

end

end