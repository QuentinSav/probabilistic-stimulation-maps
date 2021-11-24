function exe_computeSignMeanImage(obj)

% Compute the significant mean image
% Set the insignificant voxels from mean-image to zero
obj.map.significantMean = obj.map.mean;
% obj.map.significantMean.img(obj.map.p.img > obj.param.pThreshold) = NaN;

betterNaNMask = obj.map.betterMask;
betterNaNMask(isnan(betterNaNMask)) = 1;
worseMask = ~betterNaNMask;
betterMask = obj.map.betterMask;
betterMask(isnan(obj.map.betterMask)) = 0;
betterMask = logical(betterMask);

obj.map.significantBetterMean.img = zeros(obj.features.containerSize);
obj.map.significantBetterMean.mat = obj.map.mean.mat;
obj.map.significantBetterMean.img(betterMask & obj.map.p.img < obj.param.pThreshold) = ...
    obj.map.significantMean.img(betterMask & obj.map.p.img < obj.param.pThreshold);
obj.map.significantWorseMean.img(worseMask & obj.map.p.img < obj.param.pThreshold) = ...
    obj.map.significantMean.img(worseMask & obj.map.p.img < obj.param.pThreshold);

% Compute the sweet spot
obj.map.sweetspot.ratio = 0.1;

nSignBetterVoxels = nnz(obj.map.significantBetterMean.img);
nMax = round(nSignBetterVoxels*obj.map.sweetspot.ratio);
[~, index] = sort(obj.map.significantBetterMean.img(:), 1, 'descend');

obj.map.sweetspot = obj.map.significantBetterMean;
obj.map.sweetspot.img = zeros(size(obj.map.significantBetterMean.img));
    obj.map.sweetspot.img(index(1:nMax)) = 1;

end