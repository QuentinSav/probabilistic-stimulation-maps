function permutedScores = util_computePermutedScores(obj, nPermutationImages)
%
%
% !!! THIS FUNCTION IS AN APPROXIMATION !!!
% The dependencies between scores from a same lead and the correlation
% between score and amplitude is ignored.

obj.param.nPermutationImages = nPermutationImages;
permutedIndex = NaN(obj.data.training.n, obj.param.nPermutationImages);

% Initialize permuted scores array
permutedScores = NaN(obj.param.nPermutationImages, obj.features.n);

for k = 1:obj.param.nPermutationImages
    
    index = 1:obj.data.training.n;
    permutedIndex(:, k) = index(randperm(obj.data.training.n));

end

% Creates a table with the permuted score of each VTA
scoresPermutationTable = obj.data.training.table.clinicalScore(permutedIndex);

% Assign the permuted score to each feature
permutedScores = scoresPermutationTable(obj.features.indexVTAs', :);

end