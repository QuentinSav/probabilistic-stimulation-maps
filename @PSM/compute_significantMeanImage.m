function compute_significantMeanImage(obj)

obj.pThreshold = 0.05;

% Compute the significant mean image
% Set the insignificant voxels from mean-image to zero
obj.significantMeanImage = obj.meanImage;
obj.significantMeanImage.img(obj.pImage.img > obj.sweetspot.significanceThreshold) = 0;


% Compute the sweet spot
nSignVoxels = nnz(obj.significantMeanImage.img);
nMax = round(nSignVoxels/10);
[~, index] = sort(obj.significantMeanImage.img(:), 1, 'descend');

obj.sweetspot = obj.significantMeanImage;
obj.sweetspot.img = zeros(size(obj.significantMeanImage.img));
obj.sweetspot.img(index(1:nMax)) = 1;

end