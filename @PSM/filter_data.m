function filter_data(obj)
    % The hemisphere property can be ['left', 'right', 'both'].
    % This function filters the data in function of the desired hemisphere. 

    if strcmpi(obj.hemisphere, 'left') 
        % All the leads ID containing .5 are implanted in the left
        % hemisphere
        obj.clinicalData = obj.clinicalData(logical(mod(2*obj.clinicalData.leadID, 2)), :);
    
    elseif strcmpi(obj.hemisphere, 'right') 
        % All the leads ID containing .0 are implanted in the right
        % hemisphere
        obj.clinicalData = obj.clinicalData(~logical(mod(2*obj.clinicalData.leadID, 2)), :);
    
    end
end