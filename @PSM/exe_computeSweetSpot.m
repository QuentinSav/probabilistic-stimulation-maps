function exe_computeSweetSpot(obj, method, varargin)

if strcmpi(method, 'percentile')

    % Assign the sweetspot ratio of the significant better mean image
    obj.param.sweetspotRatio = varargin{1};

    % Get the threshold value for the mean
    meanThreshold = prctile(obj.map.significantBetterMean.img(~isnan(obj.map.significantBetterMean.img)), obj.param.sweetspotRatio);

    % Create sweetspot
    obj.map.sweetspot = obj.map.containerTemplate;
    obj.map.sweetspot.img(obj.map.significantBetterMean.img > meanThreshold) = 1;

elseif strcmpi(method, 'largestCluster')

    %create a binary image of the significant better
    binarySignBetterMean = obj.map.significantBetterMean.img;
    binarySignBetterMean(isnan(binarySignBetterMean)) = 0;
    binarySignBetterMean(binarySignBetterMean > 0) = 1;

    % Get the connected voxels
    clusters = bwconncomp(binarySignBetterMean);

    % Create sweetspot
    obj.map.sweetspot = obj.map.containerTemplate;

    if ~isempty(clusters.PixelIdxList)
        obj.map.sweetspot.img(clusters.PixelIdxList{1}) = 1;
    end
end

end