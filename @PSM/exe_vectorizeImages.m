function exe_vectorizeImages(obj)

nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);

% TODO check the orientation
obj.features.vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.training.n)';
obj.features.vectorizedVTAs(isnan(obj.features.vectorizedVTAs)) = 0;
obj.features.vectorizedScores = obj.data.training.table.clinicalScore;

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