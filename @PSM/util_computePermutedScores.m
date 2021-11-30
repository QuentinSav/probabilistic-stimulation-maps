function permutedScores = util_computePermutedScores(obj, nPermutationImages)
%  
% 
% !!! THIS FUNCTION IS AN APPROXIMATION !!!
% The dependencies between scores from a same lead and the correlation
% between score and amplitude is ignored.

obj.param.nPermutationImages = nPermutationImages;
permutedIndex = NaN(obj.data.training.n, obj.param.nPermutationImages);

    for k = 1:obj.param.nPermutationImages
        
        index = 1:obj.data.training.n;
        permutedIndex(:, k) = index(randperm(obj.data.training.n));

    end
    
    permutedScores = obj.data.training.table.clinicalScore(permutedIndex);

end