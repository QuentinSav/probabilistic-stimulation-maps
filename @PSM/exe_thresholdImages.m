function exe_thresholdImages(obj, thresholdValue)

obj.map.n.img(obj.map.n.img < thresholdValue) = 0;
obj.map.mean.img(obj.map.n.img < thresholdValue) = 0;
obj.map.h0.img(obj.map.n.img < thresholdValue) = 0;

end