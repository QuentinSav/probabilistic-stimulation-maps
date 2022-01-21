function util_setFilter(obj, method)
% Resliced VTA may include some non-binary values. This function that set 
% the filter applied to the VTA. 
%
% Input: - method:    'rounded', 'raw'

    if strcmpi(method, 'rounded')
        obj.param.filterImg = @(image) roundVoxel(image);
    
    elseif strcmpi(method, 'raw')
        obj.param.filterImg = @(image) image;
    
    elseif strcmpi(method, 'reduced')
        obj.param.filterImg = @(image) reduce(image);
    
    end


end

function image = roundVoxel(image)
   
   image.img = round(image.img);

end

function image = reduce(image)

   image.img = convn(image.img, ones(2,2,2), 'valid')/8;
   image.img = image.img(1:2:end, 1:2:end, 1:2:end);
   
   image.mat(1, 4) = image.mat(1, 4)-image.mat(1, 1); 
   image.mat(1, 1) = image.mat(1, 1)*2;
   image.mat(2, 4) = image.mat(2, 4)-image.mat(2, 2);
   image.mat(2, 2) = image.mat(2, 2)*2;
   image.mat(3, 4) = image.mat(3, 4)-image.mat(3, 3);
   image.mat(3, 3) = image.mat(3, 3)*2;

   image.img = convn(image.img, ones(2,2,2), 'valid')/8;
   image.img = image.img(1:2:end, 1:2:end, 1:2:end);
   
   image.mat(1, 4) = image.mat(1, 4)-image.mat(1, 1); 
   image.mat(1, 1) = image.mat(1, 1)*2;
   image.mat(2, 4) = image.mat(2, 4)-image.mat(2, 2);
   image.mat(2, 2) = image.mat(2, 2)*2;
   image.mat(3, 4) = image.mat(3, 4)-image.mat(3, 3);
   image.mat(3, 3) = image.mat(3, 3)*2;


end