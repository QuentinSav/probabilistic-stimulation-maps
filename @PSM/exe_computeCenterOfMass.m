function exe_computeCenterOfMass(obj)
% Compute the center of mass of the current sweetspot

% Transform NaN into 0s
sweetspot = obj.map.sweetspot.img;
sweetspot(isnan(obj.map.sweetspot.img)) = 0;

% Get the voxels included in the sweetspot
voxelsIndex = find(sweetspot);

% Get the coordinates of the voxels
[xx, yy, zz] = ind2sub(size(obj.map.sweetspot.img), voxelsIndex);

% Get the center of mass in voxel space
CoM_voxelspace = [mean(xx), mean(yy), mean(zz)];

% Transform the center of mass into the MNI space
obj.results.CoM(obj.param.kFold, :) = PSM.util_transform(CoM_voxelspace, obj.map.sweetspot, 'VoxelToWorld');

end