function VTA = util_loadVTA(obj, varargin)
% Input:    - index or filename
% Output:   - VTA NIFTI image structure

if isnumeric(varargin{1})
    
    if strcmpi(obj.state, 'training')
        VTA = ea_load_nii(obj.data.training.table.filename{varargin{1}});

    elseif strcmpi(obj.state, 'testing')
        VTA = ea_load_nii(obj.data.testing.table.filename{varargin{1}});

    else
        VTA = ea_load_nii(obj.data.clinical.table.filename{varargin{1}});
        
    end

elseif ischar(varargin{1})
    VTA = ea_load_nii(varargin{1});

end

% Apply filter to the loaded image
VTA.img = obj.param.filterImg(VTA.img);

end