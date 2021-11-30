function Q = util_getSummaryStat(obj, pImage)
% Function to compute the Q summary statistic of a p-image.
%
% Input:  - pImage:  the p-image
% 
% Output: - Q:       summary statistic

    Q = sum(-log(pImage.img(pImage.img < obj.param.pThreshold)), 'all');

end