function exe_normalizeScores(obj)

maxN = max([obj.data.training.table.nVoxel; obj.data.testing.table.nVoxel]);

for k = 1:obj.data.training.n

    obj.features.regression.y.training(k) = ...
        obj.features.regression.y.training(k) * (obj.data.training.table.nVoxel(k)/maxN);

end

for k = 1:obj.data.testing.n

    obj.features.regression.y.testing(k) = ...
        obj.features.regression.y.testing(k) * (obj.data.testing.table.nVoxel(k)/maxN);

end

end