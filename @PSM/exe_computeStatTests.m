function pImage = exe_computeStatTests(obj, statTestType, h0Type)

disp('--------------------------------------------------');
disp('Computing statistical tests');

obj.param.alpha = 0.05;

% Initial
pImage = NaN(obj.features.containerSize);
betterMaskImage = NaN(obj.features.containerSize);

% Define the null hypothesis
if strcmpi(h0Type, 'zero')
    get_h0 = @(voxel) 0;

elseif strcmpi(h0Type, 'h0_meanScoreAmplitude')
    get_h0 = @(voxel) obj.map.h0.img(voxel(1), voxel(2), voxel(3));

elseif strcmpi(h0Type, 'h0_scoresExcludeVox')
    get_h0 = @(voxel) obj.map.h0(voxel(1), voxel(2), voxel(3), :);

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
    [pImage(xx, yy, zz), betterMaskImage(xx, yy, zz)] = statTest(obj.map.scoresArray, xx, yy, zz, h0);
    
    k = k + 1;

end

% Assign the property pImage
obj.map.p.mat = obj.map.n.mat;
obj.map.p.img = pImage;
obj.map.betterMask = betterMaskImage;

end

% Statistical tests -------------------------------------------------------
function [p, signBetter] = exactWilcoxon(scoresArray, xx, yy, zz, h0)

    p = signrank(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0), 'tail', 'right', 'method', 'exact');

    signBetter = median(squeeze(scoresArray(xx, yy, zz, :))) > median(squeeze(h0));

end

function [p, signBetter] = approxWilcoxon(scoresArray, xx, yy, zz, h0)

    p = signrank(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0), 'tail', 'right', 'method', 'approximate');

    signBetter = median(squeeze(scoresArray(xx, yy, zz, :))) > median(squeeze(h0));

end

function [p, signBetter] = t_test(scoresArray, xx, yy, zz, h0)

    [~, p, ~, stats] = ttest2(squeeze(scoresArray(xx, yy, zz, :)), ...
        squeeze(h0));

    signBetter = stats.tstat > 0;
   
end