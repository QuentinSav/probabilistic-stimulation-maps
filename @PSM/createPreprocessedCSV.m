function createPreprocessedCSV(obj)

obj.util_setFilter('rounded');
obj.exe_compileFeatures({'coord', 'indexVTAs', 'weights', 'scores'});
obj.exe_computeFeatureImages({'n', 'mean', 'scoresArray'});
obj.exe_vectorizeImages;    


%writematrix(obj.features.regression.X.clinical, 'X.csv');
%writematrix(obj.features.regression.y.clinical, 'y.csv');
writetable(obj.data.clinical.table, 'table.csv');

end