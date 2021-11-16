function set_filter(obj, method)
    if strcmpi(method, 'rounded')
        obj.filterImg = @(image) round(image);
    
    elseif strcmpi(method, 'weighted')
        obj.filterImg = @(image) image;
    
    end
end