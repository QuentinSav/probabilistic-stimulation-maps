function util_dataScreening(obj)
    % The hemisphere property can be ['left', 'right', 'both'].
    % This function filters the data in function of the desired hemisphere. 
    
    

    if strcmpi(obj.data.screen.hemisphere, 'left') 
        % All the leads ID containing .5 are implanted in the left
        % hemisphere
        obj.data.clinical.table = obj.data.clinical.table(logical(mod(2*obj.data.clinical.table.leadID, 2)), :);
    
    elseif strcmpi(obj.data.screen.hemisphere, 'right') 
        % All the leads ID containing .0 are implanted in the right
        % hemisphere
        obj.data.clinical.table = obj.data.clinical.table(~logical(mod(2*obj.data.clinical.table.leadID, 2)), :);
    
    end
end