function createPreprocessedCSV(obj)

obj.util_setFilter('rounded');
obj.exe_compileFeatures({'coord', 'indexVTAs', 'weights', 'scores'});
obj.exe_computeFeatureImages({'n', 'mean', 'scoresArray'});
obj.exe_vectorizeImages;    

X = obj.features.regression.X.clinical;
y = obj.features.regression.y.clinical;
table = obj.data.clinical.table;

save('data.mat', 'X', 'y', 'table');

end