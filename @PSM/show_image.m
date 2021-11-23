function show_image(obj, imageToPlot, holdFlag, colorName)

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
        case 'n-image'
            image = obj.map.n;

        case 'mean-image'
            image = obj.map.mean;

        case 'h0-image'
            image = obj.map.h0;

        case 'p-image'
            image = obj.map.p;

        case 'significantBetterMean'
            image = obj.map.significantBetterMean;
        
        case 'significantWorseMean'
            image = obj.map.significantWorseMean;
        
        case 'SweetSpot'
            image = obj.map.sweetspot;

    end

    ptCloud = obj.util_nii2voxelArray(image, 'coord', 'mni');

else

    ptCloud = obj.util_nii2voxelArray(imageToPlot, 'coord', 'mni');

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

%title(imageToPlot);

xx = ptCloud.coord(:, 1);
yy = ptCloud.coord(:, 2);
zz = ptCloud.coord(:, 3);

scatter3(xx, yy, zz, 1, ptCloud.intensity);
colorbar;
caxis([0 max(image.img, [], 'all')]);

end