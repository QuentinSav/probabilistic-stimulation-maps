function Q = util_getSummaryStat(obj, pImage)
% Function to compute the Q summary statistic of a p-image.
%
% Input:  - pImage:  the p-image/ array of p-images
%
% Output: - Q:       summary statistic

for k = 1:length(pImage)
    Q(k) = sum(-log(pImage(k).img(pImage(k).img < obj.param.pThreshold)), 'all');
    
end
end