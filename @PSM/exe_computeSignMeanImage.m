function compute_significantMeanImage(obj)

% Compute the significant mean image
% Set the insignificant voxels from mean-image to zero
obj.significantMeanImage = obj.meanImage;
obj.significantMeanImage.img(obj.pImage.img > obj.pThreshold) = 0;

% Compute the sweet spot
obj.sweetspot.ratio = 0.1;
nSignVoxels = nnz(obj.significantMeanImage.img);
nMax = round(nSignVoxels*obj.sweetspot.ratio);
[~, index] = sort(obj.significantMeanImage.img(:), 1, 'descend');

obj.sweetspot = obj.significantMeanImage;
obj.sweetspot.img = zeros(size(obj.significantMeanImage.img));
obj.sweetspot.img(index(1:nMax)) = 1;

end