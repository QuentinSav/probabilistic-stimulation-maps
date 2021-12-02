function exe_vectorizeImage(obj)

nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);

% TODO check the orientation
obj.features.vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.training.n);


end