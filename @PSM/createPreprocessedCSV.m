function createPreprocessedCSV(obj, voxelSize)

if  ~exist('voxelSize', 'var')
    voxelSize = 'original';

end

disp("Reslicing voxsize = " + voxelSize);

obj.util_setFilter('rounded');

if ~strcmpi(voxelSize, 'original')
    new_folder = ['../../03_Data/reslicedVTAsLeft/', num2str(1000*voxelSize), 'um/'];
    
    if  ~exist(new_folder, 'dir')
        mkdir(new_folder)
    
    end
    
    for k = 1:obj.data.clinical.n
        
        new_filename = [new_folder, num2str(k), '.nii'];
        ea_reslice_nii(obj.data.clinical.table.filename{k}, new_filename, voxelSize, false, 0, 1);
        obj.data.clinical.table.filename{k} = new_filename;
    
    end
end

obj.exe_compileFeatures({'coord', 'indexVTAs', 'weights', 'scores'});
obj.exe_computeFeatureImages({'n', 'mean', 'scoresArray', 'weightsArray'});
obj.exe_vectorizeImages;    

X = obj.features.regression.X.clinical;
y = obj.features.regression.y.clinical;
container = obj.map.containerTemplate;

%ea_save_nii(container, 'container.nii');
container_affine = container.mat;
container_shape = size(container.img);

if strcmpi('voxelSize', 'original')
    X = logical(X);
end

save(["../../03_Data/ML_datasets/dataset_" + 1000*voxelSize + "um.mat"], "X", "y", "container_affine", "container_shape")

end