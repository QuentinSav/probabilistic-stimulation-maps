function newCoordinates = transform(oldCoordinates, image, direction)
    % Input:    - OldCoordinates:   Array [mx3]
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