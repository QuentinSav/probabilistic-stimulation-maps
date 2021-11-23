function meanScoresFeatures = util_getMeanScoreSameAmplitude(obj)
% Function that computes the mean score of all the VTA with the same
% amplitude. 
%
% Output: - meanScoresFeatures:     array of the same length than the 
%                                   number of activated voxels.

% Get the list of amplitude used in the training data
amplitudeKeys = unique(obj.data.training.table.amplitude);

% Initialize the array for the mean s
meanScoreValues = NaN(length(amplitudeKeys));
meanScoresFeatures = NaN(obj.features.n, 1);

for k = 1:length(amplitudeKeys)
    % Compute the mean score for a given stimulation amplitude
    meanScoreValues(k) = mean(obj.trainingData.score(obj.data.training.table.amplitude == amplitudeKeys(k)));

end

% Create a "dictionnary"
meanScoresMap = containers.Map(amplitudeKeys, meanScoreValues);

nDigit = 0;

for k = 1:obj.features.n
    % Progress feedback to user
    if mod(k, 10000) == 0 || k == obj.features.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('Mean-Score: voxel # %d / %d\n', k, obj.features.n);
    end
    
    % Assign the mean-score of the same amplitude VTA to each activated
    % voxels
    meanScoresFeatures(k) = meanScoresMap(obj.features.stimAmplitudes(k));

end
end