function exe_getScoreWeights(obj)

if strcmpi(obj.state, 'test')
    return;
end
nBin = 10;
edges = linspace(0, 1, nBin + 1);

[N, ~, bin] = histcounts(obj.data.training.table.clinicalScore, edges);

nEmptyBin = length(N(N == 0));

weights = bin;
for k = 1:nBin
    weights(weights==k) = obj.data.training.n/(N(k)*(nBin-nEmptyBin));

end

    obj.features.logRegression.w = weights;

end