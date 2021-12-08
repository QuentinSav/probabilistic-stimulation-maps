function exe_vectorizeImages(obj)

nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);

if strcmpi(obj.state, 'training')
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.training.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedVTAs(vectorizedVTAs ~= 0) = 1;
    
    % Add intercept term
    vectorizedVTAs = [ones(obj.data.training.n, 1) vectorizedVTAs];
    obj.features.vectorizedVTAs.training = vectorizedVTAs;

    vectorizedScores = obj.data.training.table.clinicalScore;
    obj.features.vectorizedScores.training = vectorizedScores;

elseif strcmpi(obj.state, 'testing')
    
    
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.testing.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedVTAs(vectorizedVTAs ~= 0) = 1;

    % Add intercept term
    vectorizedVTAs = [ones(obj.data.testing.n, 1) vectorizedVTAs];
    obj.features.vectorizedVTAs.testing = vectorizedVTAs;

    vectorizedScores = obj.data.testing.table.clinicalScore;
    obj.features.vectorizedScores.testing = vectorizedScores;

end    

end