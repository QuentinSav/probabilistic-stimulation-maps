function compute_nImage(obj, method)

disp('--------------------------------------------------');
disp('Computing n-image');

% Initialize map
nImage = zeros(obj.features.coordSize);

% If method is rounded, the n-image will not include 
if strcmp(method, 'rounded')
    obj.features.weights = round(obj.features.weights);

end

nDigit = 0;

for k = 1:obj.features.n

    % Print only for multiples of 10'000
    if mod(k, 100000) == 0 || k == obj.features.n
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('n-image: Processing feature # %d / %d\n', k, obj.features.n);
    end
    
    xx = obj.features.coord(k, 1);
    yy = obj.features.coord(k, 2);
    zz = obj.features.coord(k, 3);
    nImage(xx, yy, zz) = nImage(xx, yy, zz) + obj.features.weights(k);

end

% Create NIFTI image with the mean-image
obj.nImage = ea_make_nii(nImage, obj.voxelSize, - obj.features.coordOffset);
obj.nImage.mat = diag([obj.voxelSize, 1]);
obj.nImage.mat(1:3, 4) = obj.features.coordOffset.*obj.voxelSize;

end