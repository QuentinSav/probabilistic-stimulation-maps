function createPreprocessedCSV(obj, voxelSize)


disp("Reslicing voxsize = " + voxelSize);

obj.util_setFilter('raw');

new_folder = ['../../03_Data/reslicedVTAs/', num2str(1000*voxelSize), 'um/'];

if  ~exist(new_folder, 'dir')
    mkdir(new_folder)

end

for k = 1:obj.data.clinical.n
    
    new_filename = [new_folder, num2str(k), '.nii'];
    ea_reslice_nii(obj.data.clinical.table.filename{k}, new_filename, voxelSize, false, 0, 3);
    obj.data.clinical.table.filename{k} = new_filename;

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

save(["../../03_Data/ML_datasets/dataset_" + 1000*voxelSize + "um.mat"], "X", "y", "container_affine", "container_shape")

end