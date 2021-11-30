function pImage = exe_computeStatTests(obj, statTestType, h0Type)

disp('--------------------------------------------------');
disp('Computing statistical tests');

% Initialize p and better-worse mask images
obj.map.p = obj.map.containerTemplate;
obj.map.betterMask = obj.map.containerTemplate;
obj.map.worseMask = obj.map.containerTemplate;

% Define the null hypothesis
if strcmpi(h0Type, 'zero')
    get_h0 = @(voxel) 0;

elseif strcmpi(h0Type, 'h0MeanScoreAmplitude')
    get_h0 = @(voxel) obj.map.h0.img(voxel(1), voxel(2), voxel(3));

elseif strcmpi(h0Type, 'h0ScoresExcludeVox')
    get_h0 = @(voxel) obj.map.h0.img(voxel(1), voxel(2), voxel(3), :);

end

% Define the  voxel-wise statistical test
if strcmpi(statTestType, 'exactWilcoxon')
    statTest = @exactWilcoxon;

elseif strcmpi(statTestType, 'approxWilcoxon')
    statTest = @approxWilcoxon;

elseif strcmpi(statTestType, 't-test')
    statTest = @t_test;

end

% Get the voxel to be tested in the n-Image
voxels = obj.util_nii2voxelArray(obj.map.n, 'coord', 'voxel');

k = 1;
nDigit = 0;

for voxel = voxels.coord'
    
    % Progress feedback to the user
    if mod(k, 1000) == 0 || k == length(voxels.coord)
        fprintf(repmat('\b', 1, nDigit));
        nDigit = fprintf('Processing voxel # %d / %d\n', k, length(voxels.coord));

    end
    
    % Get coordinates of the voxel in integers
    xx = voxel(1);
    yy = voxel(2);
    zz = voxel(3);
    
    % Get the null-hypothesis
    h0 = get_h0(voxel);
    
    % Compute the p-value of the statistical test
    [obj.map.p.img(xx, yy, zz), obj.map.betterMask.img(xx, yy, zz)] = ...
        statTest(obj.map.scoresArray.img, xx, yy, zz, h0);
    
    k = k + 1;

end

% Filter NaN values from better-worse masks
obj.map.worseMask.img = obj.map.betterMask.img;
obj.map.worseMask.img(isnan(obj.map.worseMask.img)) = 1;
obj.map.worseMask.img = ~obj.map.worseMask.img;

obj.map.betterMask.img(isnan(obj.map.betterMask.img)) = 0;

% Convert better-worse maask to logical images
obj.map.betterMask.img = logical(obj.map.betterMask.img);
obj.map.worseMask.img = logical(obj.map.worseMask.img);

end

% Statistical tests -------------------------------------------------------
function [p, better] = exactWilcoxon(scoresArray, xx, yy, zz, h0)

    p = signrank(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0), 'tail', 'both', 'method', 'exact');
    
    p = p/2;

    better = median(squeeze(scoresArray(xx, yy, zz, :)), 'omitnan') > median(squeeze(h0), 'omitnan');

end

function [p, better] = approxWilcoxon(scoresArray, xx, yy, zz, h0)

    p = signrank(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0), 'tail', 'both', 'method', 'approximate');
    
    p = p/2;

    better = median(squeeze(scoresArray(xx, yy, zz, :)), 'omitnan') > median(squeeze(h0), 'omitnan');

end

function [p, better] = t_test(scoresArray, xx, yy, zz, h0)

    [~, p, ~, stats] = ttest2(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0));

    better = stats.tstat > 0;
    % TODO check when NaN
   
end