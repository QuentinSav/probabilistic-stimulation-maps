function util_computePermutationImages(obj)


disp('--------------------------------------------------');
disp('Computing permutation images');

for k = 1:obj.param.nPermutationImages
    
    disp("Image " + k + "/" + obj.param.nPermutationImages);
    
    nPermImage = zeros(obj.features.containerSize);
    sumPermImage = zeros(obj.features.containerSize);
    
    nDigit = 0;

    for l = 1:obj.features.n
        %
        if mod(k, 100000) == 0 || k == obj.features.n
            fprintf(repmat('\b', 1, nDigit));
            nDigit = fprintf('Feature # %d / %d\n', k, obj.features.n);
        end

        % Get coordinates of the voxel in integers
        xx = obj.features.coord(l, 1);
        yy = obj.features.coord(l, 2);
        zz = obj.features.coord(l, 3);

        nPermImage(xx, yy, zz) = nPermImage(xx, yy, zz) + 1;
        sumPermImage(xx, yy, zz) = sumPermImage(xx, yy, zz) + obj.features.permutedScores(k, l);

    end

    % Get the container template for the h0-image
    obj.map.permutation{k}.mean = obj.map.containerTemplate;
    
    obj.map.permutation{k}.mean.img = sumPermImage/nPermImage;

end

end