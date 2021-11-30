function util_computePermutationStatTests(obj)

disp('--------------------------------------------------');
disp('Computing permutation p-images');

for k = 1:obj.param.nPermutationImages
    
    disp("Image " + k + "/" + obj.param.nPermutationImages);
    
    targetImage.type = 'permutation';
    targetImage.k = k;

    obj.exe_computeStatTests('approxWilcoxon', 'h0MeanScoreAmplitude', targetImage);

end
end