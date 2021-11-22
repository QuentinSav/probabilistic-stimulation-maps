function exe_computeFalsePosCorrection(obj, method)
    % Function to apply type 1 error (false positive) either by adjusting
    % the p-values of the statistical tests or modifying the
    % null-hypothesis rejection threshold (alpha otherwise) depending on
    % the method

    if strcmpi(method, 'Benjamini-Hochberg')

        % Get features array from the p-image
        voxelsArray = obj.nii2voxelArray(obj.pImage, 'array', 'voxels');

        % Sort the arrays of p-values and the coordinates 
        [pValuesOrdered, index] = sort(voxelsArray.intensity, 1, "descend");
        coordOrdered = voxelsArray.coord(index, :);

        % Get the total number of tests
        m = length(pValuesOrdered);
        
        % Compute the "adjusted" p-values
        for k = 1:m
            
            % Get coordinates in integers
            xx = coordOrdered(k, 1);
            yy = coordOrdered(k, 2);
            zz = coordOrdered(k, 3);
            
            % Compute the adjusted p-values
            obj.pImage.img(xx, yy, zz) = pValuesOrdered(k) * m/k;

        end
        
        % The threshold for rejecting null-hypothesis stays the same as
        % alpha
        obj.pThreshold = obj.alpha;

    elseif strcmpi(method, 'Benjamini-Hochberg, Genovese')
        
    elseif strcmpi(method, 'Bonferroni correction')

        % Get features array from the p-image (only to know the number of 
        % statistical tests)
        voxelsArray = obj.nii2voxelArray(obj.pImage, 'array', 'voxels');

        % The threshold for rejecting null-hypothesis is updated
        obj.pThreshold = obj.alpha/voxelsArray.n;

    elseif strcmpi(method, 'Permuation tests')
    
    elseif strcmpi(method, 'No correction')

        obj.pThreshold = obj.alpha;
        
    end
end
