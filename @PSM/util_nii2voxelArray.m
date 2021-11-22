function voxelArray = nii2voxelArray(obj, image, type, outputSpace)
            % Input:    - image:            NIFTI structure
            % Output:   - ptCloud:          ptCloud object

            % TODO : make it static

            if strcmpi(type, 'ptCloud')
                nColor = 250;
                cmap = parula(nColor);

                voxelsIndex = find(image.img);
                voxelsIntensity = image.img(voxelsIndex);
                [voxelsCoord(:, 1), voxelsCoord(:, 2), voxelsCoord(:, 3)] = ind2sub(size(image.img), voxelsIndex);

                if strcmpi(outputSpace, 'mni')
                    coord = obj.transform(voxelsCoord, image, 'VoxelToWorld');

                else
                    coord = voxelsCoord;

                end

                voxelsIntensity = round((nColor - 1).*voxelsIntensity./max(voxelsIntensity)) + 1;
                voxelsColor = cmap(voxelsIntensity, :);

                voxelArray = pointCloud(coord, 'Color', voxelsColor);

            elseif strcmpi(type, 'array')

                voxelsIndex = find(image.img);
                voxelsIntensity = image.img(voxelsIndex);
                [voxelsCoord(:, 1), voxelsCoord(:, 2), voxelsCoord(:, 3)] = ind2sub(size(image.img), voxelsIndex);

                if strcmpi(outputSpace, 'mni')
                    voxelArray.coord = obj.transform(voxelsCoord, image, 'VoxelToWorld');

                else
                    voxelArray.coord = voxelsCoord;

                end

                voxelArray.intensity = voxelsIntensity;
                voxelArray.n = length(voxelArray.intensity);

            elseif strcmpi(type, 'index')

                voxelArray.index = find(image.img);
                voxelArray.intensity = image.img(voxelArray.index);
                voxelArray.n = length(voxelArray.intensity);

            end
        end