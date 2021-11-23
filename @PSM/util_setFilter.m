function util_setFilter(obj, method)
% Resliced VTA may include some non-binary values. This function that set 
% the filter applied to the VTA. 
%
% Input: - method:    'rounded', 'raw'

    if strcmpi(method, 'rounded')
        obj.param.filterImg = @(image) round(image);
    
    elseif strcmpi(method, 'raw')
        obj.param.filterImg = @(image) image;
    
    end
end