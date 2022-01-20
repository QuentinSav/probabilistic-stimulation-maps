function createPreprocessedCSV(obj)

obj.util_setFilter('rounded');
obj.exe_compileFeatures({'coord', 'indexVTAs', 'weights', 'scores'});
obj.exe_computeFeatureImages({'n', 'mean', 'scoresArray'});
obj.exe_vectorizeImages;    

X = logical(obj.features.regression.X.clinical);
y = obj.features.regression.y.clinical;
container = obj.map.containerTemplate;

ea_save_nii(container, 'container.nii');

save('data.mat', "X", "y")
end