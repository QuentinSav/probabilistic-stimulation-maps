function exe_computeSignMeanImage(obj)

% Initializer the significant mean images
obj.map.significantMean = obj.map.containerTemplate;
obj.map.significantBetterMean = obj.map.containerTemplate;
obj.map.significantWorseMean = obj.map.containerTemplate;

% Get the significant mean
obj.map.significantMean.img = obj.map.mean.img;
obj.map.significantMean.img(obj.map.p.img > obj.param.pThreshold) = NaN;

% Getter the significant better-worse mean
obj.map.significantBetterMean.img(obj.map.betterMask.img) = ...
    obj.map.significantMean.img(obj.map.betterMask.img);

obj.map.significantWorseMean.img(obj.map.worseMask.img) = ...
    obj.map.significantMean.img(obj.map.worseMask.img);

end