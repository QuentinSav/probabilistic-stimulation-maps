function newCoordinates = util_transform(oldCoordinates, image, direction)
% Function used to perform an homogenous transform between a given space 
% and voxel space
%
% Input:    - oldCoordinates:   Array [mx3]
%           - image:            NIFTI structure
%           - direction:        'VoxelToWorld' or 'WorldToVoxel'
% Output:   - newCoordinates:   Array [mx3]

if strcmpi(direction, 'VoxelToWorld')
    oldCoordinates = [oldCoordinates'; ones(1, size(oldCoordinates, 1))];
    newCoordinates = image.mat*oldCoordinates;
    newCoordinates = newCoordinates(1:3, :)';

elseif strcmpi(direction, 'WorldToVoxel')
    oldCoordinates = [oldCoordinates'; ones(1, size(oldCoordinates, 1))];
    newCoordinates = image.mat\oldCoordinates;
    newCoordinates = round(newCoordinates);
    newCoordinates = newCoordinates(1:3, :)';

end
end