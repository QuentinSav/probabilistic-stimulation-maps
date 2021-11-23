function test(obj)
    
    disp('--------------------------------------------------');
    disp('TESTING');
    
    obj.state = 'testing';
    
    for k = 1:length(obj.pipeline.testing)
        obj.pipeline.testing{k}();
    end
end