function util_computePermutationImages(obj)

disp('--------------------------------------------------');
disp('Computing permutation images');

% Creates target fields in obj
obj.map.permutation = struct.empty(0, obj.param.nPermutationImages);

for k = 1:obj.param.nPermutationImages

    disp("Image " + k + "/" + obj.param.nPermutationImages);

    targetImage.type = 'permutation';
    targetImage.k = k;

    obj.exe_computeFeatureImages({'permScoresArray'}, targetImage);

end
end