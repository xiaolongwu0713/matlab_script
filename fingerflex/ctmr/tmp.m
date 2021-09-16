





%% load grey
[data.gName]=spm_select(1,'image','select image with gray matter');
brain_info=spm_vol(data.gName); [g]=spm_read_vols(brain_info);
%% load white
[data.wName]=spm_select(1,'image','select image with white matter');
brain_info2=spm_vol(data.wName); [w]=spm_read_vols(brain_info2);
