function exe_computeSignMeanImage(obj)

% Compute the significant mean image
% Set the insignificant voxels from mean-image to zero
obj.map.significantMean = obj.map.mean;
obj.map.significantMean.img(obj.map.p.img > obj.param.pThreshold) = 0;

% Compute the sweet spot
obj.map.sweetspot.ratio = 0.1;
nSignVoxels = nnz(obj.map.significantMean.img);
nMax = round(nSignVoxels*obj.map.sweetspot.ratio);
[~, index] = sort(obj.map.significantMean.img(:), 1, 'descend');

obj.map.sweetspot = obj.map.significantMean;
obj.map.sweetspot.img = zeros(size(obj.map.significantMean.img));
obj.map.sweetspot.img(index(1:nMax)) = 1;

end