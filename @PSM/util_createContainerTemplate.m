function util_createContainerTemplate(obj)
% Function that creates an empty container that can be used to initialize
% the images.

% Create a NaN image of the correct size
img = nan(obj.features.containerSize);

% Create NIFTI image with the template-image
obj.map.containerTemplate = ea_make_nii(img, obj.features.voxelSize, - obj.features.containerOffset);

% Creates the transformation matrix of the template
obj.map.containerTemplate.mat = diag([obj.features.voxelSize, 1]);
obj.map.containerTemplate.mat(1:3, 4) = obj.features.containerOffset.*obj.features.voxelSize;

end