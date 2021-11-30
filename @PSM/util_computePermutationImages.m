function util_computePermutationImages(obj)

disp('--------------------------------------------------');
disp('Computing permutation images');

for k = 1:obj.param.nPermutationImages
    
    disp("Image " + k + "/" + obj.param.nPermutationImages);
    
    targetImage.type = 'permutation';
    targetImage.k = k;

    obj.exe_computeFeatureImages({'n, mean'}, targetImage);

end

end