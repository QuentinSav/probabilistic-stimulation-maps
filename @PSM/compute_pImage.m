function pImage = compute_pImage(obj, statTest, h0Type)

disp('--------------------------------------------------');
disp('Computing p-image');

pImage = zeros(obj.features.coordSize);

if strcmpi(h0Type, 'zero')
    h0 = @(voxel) 0;

elseif strcmpi(h0Type, 'h0_meanEffAmplitude')
    h0 = @(voxel) h0Image.img(voxel(1), voxel(2), voxel(3));

end

obj.threshold(15);
voxels = obj.nii2voxelArray(obj.nImage, 'array', 'voxel');

k = 1;
nDigit = 0;

for voxel = voxels.coord'

    if mod(k, 1000) == 0 || k == length(voxels.coord)
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Processing voxel # %d / %d\n', k, length(voxels.coord));

    end

    xx = voxel(1);
    yy = voxel(2);
    zz = voxel(3);

    pImage(xx, yy, zz) = signrank(squeeze(obj.eArrayImage(xx, yy, zz, :)), h0(voxel), 'tail', 'right', 'method', 'exact');
    k = k + 1;

end

obj.pImage = obj.nImage;
obj.pImage.img = pImage;
obj.sweetspot.significanceThreshold = 0.05;

end