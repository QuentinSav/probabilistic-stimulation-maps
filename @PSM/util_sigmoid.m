function g = util_sigmoid(z)
    
    g = 1 ./ (1 + exp(-z));

end