function train(obj)
    
    disp('--------------------------------------------------');
    disp('TRAINING');
    
    obj.state = 'training';
    
    for k = 1:length(obj.pipeline.training)
        obj.pipeline.training{k}();
    end
end