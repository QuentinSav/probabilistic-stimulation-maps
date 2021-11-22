% Methods of class PSM
function hPartition = util_getValidPartition(obj, method, varargin)

if strcmpi(obj.mode, 'standard')
    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'HoldOut', 0.05, ...
        'Stratify', true);
    obj.validationMethod = [100*num2str(0.05),'% Out-of-sample'];

end

if strcmpi(method, 'LOO')
    hPartition = cvpartition(obj.data.clinical.table.centerID, 'Leaveout');
    obj.validationMethod = 'LOOCV';

elseif strcmpi(method, 'KFold')
    KFold = varargin{1};

    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'KFold', KFold, ...
        'Stratify', true);
    obj.param.validationMethod = [num2str(KFold),'-Fold CV'];

elseif strcmpi(method, 'Out-of-sample')
    holdoutRatio = varargin{1};

    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'HoldOut', holdoutRatio, ...
        'Stratify', true);
    obj.validationMethod = [100*num2str(holdoutRatio),'% Out-of-sample'];

end
end

