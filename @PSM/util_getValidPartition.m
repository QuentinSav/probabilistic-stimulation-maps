function hPartition = util_getValidPartition(obj, method, varargin)
% Function that returns the partition that will be used depending on the
% desired validation method
%
% Input:  - method:         'LOO',
%         - (holdoutRatio)  double between 0 and 1
% Output: - hPartition

% If the map computation mode is standard, no cross-validation is
% performed. A small testing is performed on 5% of the data to verify the
% validity of the map
if strcmpi(obj.mode, 'standard')
    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'HoldOut', 0.2, ...
        'Stratify', true);
    obj.param.validationMethod = [100*num2str(0.2),'% Out-of-sample'];
    return

elseif strcmpi(obj.mode, 'analysis')
    rng(100);
    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'KFold', 10, ...
        'Stratify', true);
    obj.param.validationMethod = ['10-Fold CV'];
    return

end

if strcmpi(method, 'LOO')
    % Leave-one out cross-validation
    hPartition = cvpartition(obj.data.clinical.table.centerID, 'Leaveout');
    obj.param.validationMethod = 'LOOCV';

elseif strcmpi(method, 'KFold')
    % K-fold cross-validation
    KFold = varargin{1};

    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'KFold', KFold, ...
        'Stratify', true);
    obj.param.validationMethod = [num2str(KFold),'-Fold CV'];

elseif strcmpi(method, 'Out-of-sample')
    % Leave-out cross-validation
    holdoutRatio = varargin{1};

    hPartition = cvpartition(obj.data.clinical.table.centerID, ...
        'HoldOut', holdoutRatio, ...
        'Stratify', true);
    obj.param.validationMethod = [100*num2str(holdoutRatio),'% Out-of-sample'];

end
end

