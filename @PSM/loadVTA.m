function VTA = loadVTA(obj, varargin)
% Input:    - index or filename
% Output:   - VTA NIFTI image structure

if isnumeric(varargin{1})
    
    if strcmpi(obj.state, 'training')
        VTA = ea_load_nii(obj.trainingData.filename{varargin{1}});

    elseif strcmpi(obj.state, 'validation')
        VTA = ea_load_nii(obj.validationData.filename{varargin{1}});

    elseif strcmpi(obj.state, 'idle')
        VTA = ea_load_nii(obj.clinicalData.filename{varargin{1}});
        
    end

elseif ischar(varargin{1})
    VTA = ea_load_nii(varargin{1});

end

% Either keeps the decimal values of voxels to use it as weight or
% round them ()
VTA.img = obj.filterImg(VTA.img);

end