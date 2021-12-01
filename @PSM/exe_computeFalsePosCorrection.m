function exe_computeFalsePosCorrection(obj, method, varargin)
% Function to apply type 1 error (false positive) either by adjusting
% the p-values of the statistical tests or modifying the
% null-hypothesis rejection threshold (alpha otherwise) depending on
% the method

if strcmpi(method, 'Benjamini-Hochberg')

    % Get features array from the p-image
    voxelsArray = obj.util_nii2voxelArray(obj.map.p, 'coord', 'voxels');

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
        obj.map.p.img(xx, yy, zz) = pValuesOrdered(k) * m/k;

    end

    % The threshold for rejecting null-hypothesis stays the same as
    % alpha
    obj.param.pThreshold = obj.param.alpha;

elseif strcmpi(method, 'Benjamini-Hochberg (Genovese, 2002)')
    

elseif strcmpi(method, 'Bonferroni correction')
    
    % Get features array from the p-image (only to know the number of
    % statistical tests)
    voxelsArray = obj.nii2voxelArray(obj.map.p, 'array', 'voxels');

    % The threshold for rejecting null-hypothesis is updated
    obj.pThreshold = obj.param.alpha/voxelsArray.n;

elseif strcmpi(method, 'Permutation tests')
    
    obj.param.nPermutationImages = varargin{1};
    obj.param.pThreshold = obj.param.alpha;
    
    % Compute permutation images
    obj.util_computePermutationImages();
    
    % Compute p-permutation-images
    obj.util_computePermutationStatTests();

    % Compute Q p-image
    Q = obj.util_getSummaryStat(obj.map.p);

    % Compute Q of the permutation images    
    permQ = obj.util_getSummaryStat([obj.map.permutation.p]);
    
    % Get the percentile
    if prctile(permQ, 100*obj.param.pThreshold) < Q
        obj.map.betterMask.img(obj.map.betterMask.img) = 0;
        obj.map.worseMask.img(obj.map.worseMask.img) = 0;
    
    end

elseif strcmpi(method, 'No correction')

    obj.param.pThreshold = obj.param.alpha;

end
end
