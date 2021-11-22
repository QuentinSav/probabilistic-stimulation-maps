function util_setFilter(obj, method)
    if strcmpi(method, 'rounded')
        obj.param.filterImg = @(image) round(image);
    
    elseif strcmpi(method, 'raw')
        obj.param.filterImg = @(image) image;
    
    end
end