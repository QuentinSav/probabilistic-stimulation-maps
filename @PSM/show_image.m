function showImage(obj, imageToPlot, holdFlag, colorName)

disp('--------------------------------------------------');
disp("Showing image");

if ~exist('holdFlag', 'var') == 1
    holdFlag = 0;

end

if ~exist('colorName', 'var') == 1
    colorName = '';

end

switch colorName
    case 'blue'
        color = [30, 144, 255];

    case 'red'
        color = [255, 0, 0];

    case 'black'
        color = [0, 0, 0];

    case 'orange'
        color = [255, 165, 0];

    case 'pink'
        color = [255, 20, 147];

    case 'purple'
        color = [186, 85, 211];

end

% TODO: find if the lead DBS vizualizer is open
if ischar(imageToPlot) || isstring(imageToPlot)
    switch imageToPlot
        case 'nImage'
            image = obj.nImage;

        case 'meanImage'
            image = obj.meanImage;

        case 'h0Image'
            image = obj.h0Image;

        case 'pImage'
            image = obj.pImage;

        case 'meanSignificantImage'
            image = obj.significantMeanImage;

        case 'SweetSpot'
            image = obj.sweetspot;

    end

    ptCloud = obj.nii2voxelArray(image, 'ptCloud', 'mni');

    if size(unique(ptCloud.Color, 'rows'), 1) == 1

        if ~isempty(colorName)
            ptCloud.Color = uint8(repmat(color, length(ptCloud.Location), 1));

        else
            ptCloud.Color = uint8(repmat([0 0 round(255*rand(1,1))], length(ptCloud.Location), 1));

        end
    end
else

    ptCloud = pointCloud(imageToPlot);
    if ~isempty(colorName)
        ptCloud.Color = uint8(repmat(color, length(ptCloud.Location), 1));

    else
        ptCloud.Color = uint8(repmat([0 0 round(255*rand(1,1))], length(ptCloud.Location), 1));

    end
end

h = findobj('type', 'figure', '-regexp', 'Name','Electrode-Scene');

if holdFlag && isempty(h)
    gcf;
    hold on;

elseif ~isempty(h)
    figure(h(1));
    hold on;

elseif ischar(imageToPlot) || isstring(imageToPlot)
    figure('Name', imageToPlot);

else
    figure;

end

title(imageToPlot);
pcshow(ptCloud, 'BackgroundColor', [1 1 1], 'MarkerSize', 10);
colorbar;
try % TODO Remove try by a better solution
    caxis([0 max(image.img, [], 'all')]);
end
end