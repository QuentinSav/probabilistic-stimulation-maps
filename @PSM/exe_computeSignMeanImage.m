function exe_computeSignMeanImage(obj)

% Initializer the significant mean images
obj.map.significantMean = obj.map.containerTemplate;
obj.map.significantBetterMean = obj.map.containerTemplate;
obj.map.significantWorseMean = obj.map.containerTemplate;

% Get the significant mean 
obj.map.significantMean.img = obj.map.mean.img;
obj.map.significantMean.img(obj.map.p.img < obj.param.pThreshold) = NaN;

% Getter the significant better-worse mean
obj.map.significantBetterMean.img(obj.map.betterMask.img) = ...
    obj.map.significantMean.img(obj.map.betterMask.img);

obj.map.significantWorseMean.img(obj.map.worseMask.img) = ...
    obj.map.significantMean.img(obj.map.worseMask.img);

% Compute the sweet spot
obj.map.sweetspot.ratio = 0.1;

nSignBetterVoxels = sum(~isnan(obj.map.significantBetterMean.img), "all");
nMax = round(nSignBetterVoxels*obj.map.sweetspot.ratio);
[~, indexBestMeanVoxels] = sort(obj.map.significantBetterMean.img(:), 1, 'descend');

% Remove index of NaN values
indexBestMeanVoxels(isnan(obj.map.significantBetterMean.img(:))) = [];

% Create sweetspot
obj.map.sweetspot = obj.map.containerTemplate;
obj.map.sweetspot.img(indexBestMeanVoxels(1:nMax)) = 1;
obj.map.sweetspot.img(isnan(obj.map.sweetspot.img)) = 0;

end