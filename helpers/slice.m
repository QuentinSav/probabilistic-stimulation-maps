% Plot tremor maps
% Rev06, January 2022, thuyanhkhoa.nguyen@insel.ch
% after second reviews from Annals

% REQUIREMEMT
% Open a patient in 3D MNI Space with Lead DBS, then run this script

%% mean improvement map with different ranges 
% 0--33rd percentile

meanImprovementMap = ea_load_nii( 'map.nii.gz' );
tmpIdx = find( meanImprovementMap.img ~= 0 );
uniqueMeanImprovementValues = unique( meanImprovementMap.img( tmpIdx ) );
% Autumn color map and go from red to orange to yellow
cmap = colMapGen([1 0.1 0.1], [0.1 0.1 1], 100, 'midCol',[1 1 1]);

lowerThreshold = prctile( meanImprovementMap.img( tmpIdx ), 0 );
upperThreshold = prctile( meanImprovementMap.img( tmpIdx ), 33 );
tmpIdx = find( meanImprovementMap.img > lowerThreshold & meanImprovementMap.img < upperThreshold );
colorTable = zeros( numel( tmpIdx ),3 );
for index = 1:numel( tmpIdx )
    colorTable( index, : ) = cmap( uniqueMeanImprovementValues == ...
        meanImprovementMap.img( tmpIdx( index ) ), : );
end
if ~isempty(tmpIdx)
    hold on
    [ xx, yy, zz ] = ind2sub( size( meanImprovementMap.img ), tmpIdx );
    voxelCoordinates = [ xx, yy, zz ];
    worldCoordinates = PSM.util_transform(voxelCoordinates, meanImprovementMap, 'VoxelToWorld');
    markerSize = 20;
    % use this line to plot the whole image
    indexSlice = 1:size( worldCoordinates, 1 );
    % use this line for axial slices
%     indexSlice = find( worldCoordinates( :, 3 ) == 0 );
    % or this line for sagittal 
    %indexSlice = find( worldCoordinates( :, 1 ) == 10 );
    % or this line for coronal 
    %indexSlice = find( worldCoordinates( :, 2 ) == 10 );
    
    hMeanImprovement = scatter3( worldCoordinates( indexSlice, 1 ),...
        worldCoordinates( indexSlice, 2 ),...
        worldCoordinates( indexSlice, 3 ),...
        markerSize,colorTable,'filled'); 
    hMeanImprovement.MarkerFaceAlpha = 0.8;
end

%% 34--67th percentile, delete previous map first 

tmpIdx = find( meanImprovementMap.img ~= 0 ); % reset tmpIdx
lowerThreshold = prctile( meanImprovementMap.img( tmpIdx ), 34 );
upperThreshold = prctile( meanImprovementMap.img( tmpIdx ), 67 );
tmpIdx = find( meanImprovementMap.img > lowerThreshold & meanImprovementMap.img < upperThreshold );
colorTable = zeros( numel( tmpIdx ),3 );
for index = 1:numel( tmpIdx )
    colorTable( index, : ) = cmap( uniqueMeanImprovementValues == ...
        meanImprovementMap.img( tmpIdx( index ) ),: );
end
if ~isempty(tmpIdx)
    hold on
    [ xx, yy, zz ] = ind2sub( size( meanImprovementMap.img ), tmpIdx );
    voxelCoordinates = [ xx, yy, zz ];
    worldCoordinates = PSM.util_transform(voxelCoordinates, meanImprovementMap, 'VoxelToWorld');
    markerSize = 20;
    % use this line to plot the whole image
%     indexSlice = 1:size( worldCoordinates, 1 );
    % use this line for axial slices
    indexSlice = find( worldCoordinates( :, 3 ) == 0 );
    % or this line for sagittal 
    %indexSlice = find( worldCoordinates( :, 1 ) == 10 );
    % or this line for coronal 
    %indexSlice = find( worldCoordinates( :, 2 ) == 10 );
    
    hMeanImprovement = scatter3( worldCoordinates( indexSlice, 1 ),...
        worldCoordinates( indexSlice, 2 ),...
        worldCoordinates( indexSlice, 3 ),...
        markerSize,colorTable,'filled'); 
    hMeanImprovement.MarkerFaceAlpha = 0.8;
end

%% 68--100th percentile, delete previous map first

tmpIdx = find( meanImprovementMap.img ~= 0 ); % reset tmpIdx
lowerThreshold = prctile( meanImprovementMap.img( tmpIdx ), 68 );
upperThreshold = prctile( meanImprovementMap.img( tmpIdx ), 100 );
tmpIdx = find( meanImprovementMap.img > lowerThreshold & meanImprovementMap.img < upperThreshold );
colorTable = zeros( numel( tmpIdx ),3 );
for index = 1:numel( tmpIdx )
    colorTable( index, : ) = cmap( uniqueMeanImprovementValues == ...
        meanImprovementMap.img( tmpIdx( index ) ),: );
end
if ~isempty(tmpIdx)
    hold on
    [ xx, yy, zz ] = ind2sub( size( meanImprovementMap.img ), tmpIdx );
    voxelCoordinates = [ xx, yy, zz ];
    worldCoordinates = PSM.util_transform(voxelCoordinates, meanImprovementMap, 'VoxelToWorld');
    markerSize = 20;
    % use this line to plot the whole image
%     indexSlice = 1:size( worldCoordinates, 1 );
    % use this line for axial slices
    indexSlice = find( worldCoordinates( :, 3 ) == 0 );
    % or this line for sagittal 
    %indexSlice = find( worldCoordinates( :, 1 ) == 10 );
    % or this line for coronal 
    %indexSlice = find( worldCoordinates( :, 2 ) == 10 );
    
    hMeanImprovement = scatter3( worldCoordinates( indexSlice, 1 ),...
        worldCoordinates( indexSlice, 2 ),...
        worldCoordinates( indexSlice, 3 ),...
        markerSize,colorTable,'filled'); 
    hMeanImprovement.MarkerFaceAlpha = 0.8;

end

%% Plot color bar separately

fhx = figure( 'color', 'w' );
colormap( cmap )
cb = colorbar( 'southoutside' );
caxis( [ 0 max( meanImprovementMap.img( : ) ) ] )
cb.Label.String = 'Mean improvement';

