% Methods of class PSM
function hPartition = crossValidation(obj, method, varargin)

    if strcmpi(method, 'LOO')
        hPartition = cvpartition(obj.nData, 'Leaveout');
        obj.validationMethod = 'LOOCV';

    elseif strcmpi(method, 'KFold')
        KFold = varargin{1};

        hPartition = cvpartition(obj.data.clinical.n, ...
            'KFold', KFold, ...
            'Stratify', false);
        obj.param.validationMethod = [num2str(KFold),'-Fold CV'];
        
    elseif strcmpi(method, 'Out-of-sample')
        holdoutRatio = varargin{1};

        hPartition = cvpartition(obj.nData, ...
            'HoldOut', holdoutRatio, ...
            'Stratify', false);
        obj.validationMethod = [100*num2str(holdoutRatio),'% Out-of-sample'];
        
    end
end

