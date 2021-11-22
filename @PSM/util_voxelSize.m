function voxsize = get_voxelSize(transform)
% Input:    - Transformation matrix:    Array [4x4]
% Output:   - voxel size array:         Array [3x1]

voxsize = sqrt(sum((transform * [eye(3) zeros(3,1)]').^2, 1));

end