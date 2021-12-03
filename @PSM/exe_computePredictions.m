function exe_computePredictions(obj)

for k = 1:obj.data.testing.n
    if mod(k, 10) == 0 || k == obj.data.testing.n
        fprintf(repmat('\b', 1, nDigit))
        nDigit = fprintf('Processing VTA # %d / %d\n', k, obj.data.testing.n);
    end
    
    % Load the VTA
    VTA = obj.util_loadVTA(k);
    nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);
    vectorizedVTA = reshape(VTA.img, nVoxel, 1)';
    
    obj.results.logRegression(end+1) = PSM.util_sigmoid(vectorizedVTA * obj.map.theta');

    % Prediction
    intersect(sweetspotVoxels.coord, vtaVoxels.coord, 'rows');
   
    % Score (Ground Truth)
    obj.results.score(end+1) = obj.data.testing.table.clinicalScore(k);

end