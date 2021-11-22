function voxelArray = util_nii2voxelArray(image, type, outputSpace)
% Function to convert an NIFTI image to a (non-zero) voxel array/list
% of voxels.
%
% Input:    - image:                    NIFTI structure
%           - type (optional):          'coord', 'index'
%           - outputSpace (optional):   'mni' 
% Output:   - voxelArray:               structure with fields [n, intensity, coord/index]

if strcmpi(type, 'coord')
    
    % Get the non-zeros voxel index list
    voxelsIndex = find(image.img);

    % Get the value of those voxels
    voxelArray.intensity = image.img(voxelsIndex);
    
    % Get the number of voxels
    voxelArray.n = length(voxelArray.intensity);
    
    % Convert their index to coordinates
    [voxelsCoord(:, 1), voxelsCoord(:, 2), voxelsCoord(:, 3)] = ind2sub(size(image.img), voxelsIndex);
    
    % Depending on the input argument, transform or not into MNI space
    if strcmpi(outputSpace, 'mni')
        voxelArray.coord = PSM.util_transform(voxelsCoord, image, 'VoxelToWorld');

    else
        voxelArray.coord = voxelsCoord;

    end

elseif strcmpi(type, 'index')
    
    % Get the non-zeros voxel index list
    voxelArray.index = find(image.img);

    % Get the value of those voxels
    voxelArray.intensity = image.img(voxelArray.index);
    
    % Get the number of voxels
    voxelArray.n = length(voxelArray.intensity);

end
end