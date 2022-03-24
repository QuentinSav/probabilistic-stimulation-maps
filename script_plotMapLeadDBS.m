% Plot tremor maps
	% Rev06, January 2022, thuyanhkhoa.nguyen@insel.ch
	% after second reviews from Annals
	
	% REQUIREMEMT
	% Open a patient in 3D MNI Space with Lead DBS, then run this script
	
    % Adapted from Khoa Nguyen script
	
    %% User input
    
    map_v = 'v4';
    anat_plane = 'axial';
    
    % coronal: ~ -15
    % axial: ~ -8
    % sagital:   ~ 12

    slice_mni = -8;

    %%
	map = ea_load_nii( ['../../03_Data/06_Maps/map_', map_v, '.nii.gz'] );
	tmpIdx = find(map.img);

    maxMap = max(abs(map.img), [], 'all');
	cmap = colMapGen([1 0 0], [0 0 1], 101, 'midCol', [1 1 1]);
	colorTable = zeros(numel(tmpIdx), 3);

	for index = 1:numel(tmpIdx)

        colIndex = 51+round(50*map.img(tmpIdx(index))/maxMap);

	    colorTable(index, :) = cmap(colIndex ,: );
	end
	if ~isempty(tmpIdx)
	    hold on
	    [ xx, yy, zz ] = ind2sub( size( map.img ), tmpIdx );
	    voxelCoordinates = [ xx, yy, zz ];
	    worldCoordinates = PSM.util_transform( voxelCoordinates, map, 'VoxelToWorld' );
	    markerSize = 160;

        switch anat_plane
            case 'full'
                % use this line to plot the whole image
	            indexSlice = 1:size( worldCoordinates, 1 );
            
            case 'axial'
                % use this line for axial slices
                view(0, 90)
	            indexSlice = find( worldCoordinates( :, 3 ) == slice_mni );
	    
            case 'sagital'
                % or this line for sagittal 
                view(90, 0)
	            indexSlice = find( worldCoordinates( :, 1 ) == slice_mni );
	            
            case 'coronal'
                % or this line for coronal 
                view(0, 0);
	            indexSlice = find( worldCoordinates( :, 2 ) == slice_mni );

        end
	         
	    hMeanImprovement = scatter3( worldCoordinates( indexSlice, 1 ),...
	        worldCoordinates( indexSlice, 2 ),...
	        worldCoordinates( indexSlice, 3 ),...
	        markerSize,colorTable(indexSlice, :),'filled', 's'); 
	    hMeanImprovement.MarkerFaceAlpha = 0.8;
	end
	

	%% Plot color bar separately
	
	fhx = figure( 'color', 'w' );
	colormap( cmap )
	cb = colorbar( 'southoutside' );
	caxis( [-maxMap maxMap ] )
	cb.Label.String = 'Mean improvement';
	