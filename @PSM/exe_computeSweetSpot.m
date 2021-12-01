function exe_computeSweetSpot(obj, method)

% Compute the sweet spot
obj.map.sweetspot.ratio = 0.1;

nSignBetterVoxels = sum(~isnan(obj.map.significantBetterMean.img), "all");
nMax = round(nSignBetterVoxels*obj.map.sweetspot.ratio);
[sortedArray, indexBestMeanVoxels] = sort(obj.map.significantBetterMean.img(:), 1, 'descend');

% Remove index of NaN values
indexBestMeanVoxels(isnan(sortedArray)) = [];
sortedArray(isnan(sortedArray)) = [];

% Create sweetspot
obj.map.sweetspot = obj.map.containerTemplate;
obj.map.sweetspot.img(indexBestMeanVoxels(1:nMax)) = 1;
obj.map.sweetspot.img(isnan(obj.map.sweetspot.img)) = 0;

end