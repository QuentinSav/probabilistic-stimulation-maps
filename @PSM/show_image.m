function show_image(obj, imageToPlot, holdFlag, colorName)

disp('--------------------------------------------------');
disp("Showing image");

% Initialize hold flag to 0
if ~exist('holdFlag', 'var')
    holdFlag = 0;

end

% Initialize color to blue
if ~exist('colorName', 'var')
    colorName = 'blue';

end

% Define RGB based on color name
switch colorName
    case 'blue'
        color = uint8([30, 144, 255]/255);

    case 'red'
        color = uint8([255, 0, 0]/255);

    case 'black'
        color = uint8([0, 0, 0]/255);

    case 'orange'
        color = uint8([255, 165, 0]/255);

    case 'pink'
        color = uint8([255, 20, 147]/255);

    case 'purple'
        color = uint8([186, 85, 211]/255);
    
    case 'green'
        color = uint8([124, 252, 0]/255);

end

if ischar(imageToPlot) || isstring(imageToPlot)
    % When passing a char argument
    switch imageToPlot
        case 'n'
            image = obj.map.n;
            monochrom = 0;
            
        case 'mean'
            image = obj.map.mean;
            monochrom = 0;
            
        case 'h0'
            image = obj.map.h0;
            monochrom = 0;
            
        case 'p'
            image = obj.map.p;
            monochrom = 0;
            
        case 'significantBetterMean'
            image = obj.map.significantBetterMean;
            monochrom = 0;
            
        case 'significantWorseMean'
            image = obj.map.significantWorseMean;
            monochrom = 0;
            
        case 'significantMean'
            image = obj.map.significantMean;
            monochrom = 0;

        case 'SweetSpot'
            image = obj.map.sweetspot;
            monochrom = 1;

    end

    ptCloud = obj.util_nii2voxelArray(image, 'coord', 'mni');

else
    
    % When passing a image argument 
    ptCloud = obj.util_nii2voxelArray(imageToPlot, 'coord', 'mni');
    
    if unique(ptCloud.intensity) < 2
        monochrom = 1;

    else 
        monochrom = 0;
    end
end


% Look for the lead dbs 3D-Renderer
h = findobj('type', 'figure', '-regexp', 'Name', 'Electrode-Scene');

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

% Get the points coordinates in separate variables
xx = ptCloud.coord(:, 1);
yy = ptCloud.coord(:, 2);
zz = ptCloud.coord(:, 3);

if monochrom
    scatter3(xx, yy, zz, 1, color);
else
    scatter3(xx, yy, zz, 1, ptCloud.intensity);
    colorbar;
    
    try
        caxis([0 max(image.img, [], 'all')]);

    end
end

obj.util_showTemplateSTN();

end