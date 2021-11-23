function exe_computeSignMeanImage(obj)

% Compute the significant mean image
% Set the insignificant voxels from mean-image to zero
obj.map.significantBetterMean = obj.map.mean;
betterNaNMask = obj.map.betterMask;
betterNaNMask(isnan(betterNaNMask)) = 1;
worseMask = ~betterNaNMask;
obj.map.significantBetterMean.img(obj.map.p.img > obj.param.pThreshold | worseMask) = 0;

betterMask = obj.map.betterMask;
betterMask(isnan(obj.map.betterMask)) = 0;
obj.map.significantWorseMean = obj.map.mean;
obj.map.significantWorseMean.img(obj.map.p.img > obj.param.pThreshold | betterMask) = 0;

% Compute the sweet spot
obj.map.sweetspot.ratio = 0.1;

nSignBetterVoxels = nnz(obj.map.significantBetterMean.img);
nMax = round(nSignBetterVoxels*obj.map.sweetspot.ratio);
[~, index] = sort(obj.map.significantBetterMean.img(:), 1, 'descend');

obj.map.sweetspot = obj.map.significantBetterMean;
obj.map.sweetspot.img = zeros(size(obj.map.significantBetterMean.img));
obj.map.sweetspot.img(index(1:nMax)) = 1;

end