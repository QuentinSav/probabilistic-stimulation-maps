function container = util_getContainer(obj)

% These coordinates are scaled by the inverse of voxel size in order to
% obtain a new voxel size of 1 (ie, transform all the coordinates in a
% new voxel space)
coord = coord./obj.param.voxelSize;

% Find the min values of the coordinates in order to shift it to zero
obj.features.containerOffset = min(coord) - ones(1,3);

% Shift the voxel coordinates
obj.features.coord = coord - obj.features.containerOffset;

% Get the size of the array
obj.features.containerSize = max(obj.features.coord);

end