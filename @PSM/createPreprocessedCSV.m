function createPreprocessedCSV(obj)

    


csvwrite('X.txt', obj.features.regression.X.full);
csvwrite('y.txt', obj.features.regression.y.full);
csvwrite('table.txt', 'X.txt', obj.data.clinical.table);

end