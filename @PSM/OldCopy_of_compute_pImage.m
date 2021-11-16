function pImage = compute_pImage(obj)

disp('--------------------------------------------------');
disp('Computing p-image');

switch obj.algorithm
    case 'Nguyen, 2019'

        h0 = 0;
        pMap = zeros(size(obj.nImage.img));

        obj.threshold(15);
        voxels = obj.nii2ptCloud(obj.nImage, 'array', 'voxel');
        
        k = 1;
        nDigit = 0;

        for voxel = voxels.coord'

            if mod(k, 1000) == 0 || k == length(voxels.coord)
                fprintf(repmat('\b', 1, nDigit));
                nDigit = fprintf('Processing voxel # %d / %d\n', k, length(voxels.coord));

            end
            
            pMap(voxel(1), voxel(2), voxel(3)) = signrank(squeeze(obj.eImage(voxel(1), voxel(2), voxel(3), :)), h0, 'tail', 'right', 'method', 'exact');
            k = k + 1;
            
        end

    case 'Dembek, 2019'

        i = 1;
        for k = 0:0.25:max(obj.trainingData.amplitude)

            meanEfficiency = mean(obj.trainingData.efficiency(obj.trainingData.amplitude == k));
            meanEfficienciesArray(i, :) = [k, meanEfficiency];

            i = i + 1;

        end
        % TODO

    case 'Eisenstein,'
        h0 = 0;

end

obj.pImage = obj.nImage;
obj.pImage.img = pMap;
obj.sweetspot.significanceThreshold = 0.05;

% Leave out the insignificant voxels
obj.significantMeanImage = obj.meanImage;
obj.significantMeanImage.img(obj.pImage.img > obj.sweetspot.significanceThreshold) = 0;
nSignVoxels = nnz(obj.significantMeanImage.img);
nMax = round(nSignVoxels/10);
[~, index] = sort(obj.significantMeanImage.img(:), 1, 'descend');

obj.sweetspot = obj.significantMeanImage;
obj.sweetspot.img = zeros(size(obj.significantMeanImage.img));
obj.sweetspot.img(index(1:nMax)) = 1;

end