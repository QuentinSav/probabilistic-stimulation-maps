function preprocess(obj, state)
    
    disp('--------------------------------------------------');
    disp(['PREPROCESSING: ', state, ' set']);
    
    obj.state = state;
    
    for k = 1:length(obj.pipeline.preprocessing)
        obj.pipeline.preprocessing{k}();
    end
end