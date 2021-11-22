function threshold(obj, thresholdValue)

obj.nImage.img(obj.nImage.img < thresholdValue) = 0;
obj.meanImage.img(obj.nImage.img < thresholdValue) = 0;
obj.h0Image.img(obj.nImage.img < thresholdValue) = 0;

end