function exe_computeSweetSpot(obj, method, varargin)

if strcmpi(method, 'percentile')
    % Compute the sweet spot
    obj.map.sweetspot.ratio = varargin{1};

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

elseif strcmpi(method, 'largestCluster')
    
    %create a binary image of the significant better
    binarySignBetterMean = obj.map.significantBetterMean.img;
    binarySignBetterMean(isnan(binarySignBetterMean)) = 0;
    binarySignBetterMean(binarySignBetterMean > 0) = 1;

    % Get the connected voxels
    clusters = bwconncomp(binarySignBetterMean);
    
end

end