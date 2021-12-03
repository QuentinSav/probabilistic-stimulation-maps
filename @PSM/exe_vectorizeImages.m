function exe_vectorizeImages(obj)

nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);

if strcmpi(obj.state, 'training')
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.training.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedScores = obj.data.training.table.clinicalScore;

    obj.features.vectorizedVTAs.training = vectorizedVTAs;
    obj.features.vectorizedScores.training = vectorizedScores;

elseif strcmpi(obj.state, 'testing')
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.testing.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedScores = obj.data.testing.table.clinicalScore;
    
    obj.features.vectorizedVTAs.testing = vectorizedVTAs;
    obj.features.vectorizedScores.testing = vectorizedScores;

end    

% Try to reconstruct a VTA
% reconstructedVTA = obj.map.containerTemplate;
% reconstructedVTA.img = reshape(obj.features.vectorizedVTAs(1, :), ...
%     obj.features.containerSize(1), ...
%     obj.features.containerSize(2), ...
%     obj.features.containerSize(3));
% 
% obj.show_image(reconstructedVTA);
% 
% groundTruthVTA = obj.util_loadVTA(1);
% obj.show_image(groundTruthVTA);

end