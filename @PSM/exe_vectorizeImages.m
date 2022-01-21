function exe_vectorizeImages(obj)

nVoxel = obj.features.containerSize(1)*obj.features.containerSize(2)*obj.features.containerSize(3);

if strcmpi(obj.state, 'training')
    
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.training.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedVTAs(vectorizedVTAs ~= 0) = 1;
    
    % Add interaction term
    % for k = 1:length(obj.data.training.table.amplitude)
    % vectorizedVTAs(k, :) = vectorizedVTAs(k, :) .* 1./obj.data.training.table.amplitude(k);
    % end
    
    % Add stimulation amplitude as feature
    % vectorizedVTAs = [obj.data.training.table.amplitude double(obj.data.training.table.centerID) vectorizedVTAs];

    % Add intercept term
    vectorizedVTAs = [ones(obj.data.training.n, 1) vectorizedVTAs];
    obj.features.regression.X.training = vectorizedVTAs;

    vectorizedScores = obj.data.training.table.clinicalScore + normrnd(0, 0.05, obj.data.training.n, 1);
    obj.features.regression.y.training = vectorizedScores;

elseif strcmpi(obj.state, 'testing')
    
    vectorizedVTAs = reshape(obj.map.scoresArray.img, nVoxel, obj.data.testing.n)';
    vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
    vectorizedVTAs(vectorizedVTAs ~= 0) = 1;
    
    % Add interaction term
    % for k = 1:length(obj.data.testing.table.amplitude)
    %   vectorizedVTAs(k, :) = vectorizedVTAs(k, :) .* 1./obj.data.testing.table.amplitude(k);
    % end
    
    % Add stimulation amplitude as feature
    %vectorizedVTAs = [obj.data.testing.table.amplitude double(obj.data.testing.table.centerID) vectorizedVTAs];
    
    % Add intercept term
    vectorizedVTAs = [ones(obj.data.testing.n, 1) vectorizedVTAs];
    obj.features.regression.X.testing = vectorizedVTAs;

    vectorizedScores = obj.data.testing.table.clinicalScore;
    obj.features.regression.y.testing = vectorizedScores;


else 
    
    vectorizedVTAs = reshape(obj.map.weightsArray.img, nVoxel, obj.data.clinical.n)';
%     vectorizedVTAs(isnan(vectorizedVTAs)) = 0;
%     vectorizedVTAs(vectorizedVTAs ~= 0) = 1;
    
    % Add interaction term
%     for k = 1:length(obj.data.training.table.amplitude)
%         vectorizedVTAs(k, :) = vectorizedVTAs(k, :) .* 1./obj.data.training.table.amplitude(k);
%     end
    
    % Add stimulation amplitude as feature
    % vectorizedVTAs = [obj.data.clinical.table.amplitude double(obj.data.clinical.table.centerID) vectorizedVTAs];

    % Add intercept term
    vectorizedVTAs = [ones(obj.data.clinical.n, 1) vectorizedVTAs];
    obj.features.regression.X.clinical = vectorizedVTAs;

    vectorizedScores = obj.data.clinical.table.clinicalScore;
    obj.features.regression.y.clinical = vectorizedScores;


end    

end