
%% load axial
[data.gName]=spm_select(1,'image','select axial image');
brain_info=spm_vol(data.gName); [ax]=spm_read_vols(brain_info);

%% load sagittal
[data.gName]=spm_select(1,'image','select sagittal image');
brain_info=spm_vol(data.gName); [sag]=spm_read_vols(brain_info);


%%

mm=0*ax;

for x = 1:91, 
    for y = 1:109,
        for z = 1:91
    if ax(x,y,z)==0,  ax(x,y,z)=sag(x,y,z); end
    if sag(x,y,z)==0, sag(x,y,z)=ax(x,y,z); end
    mm(x,y,z)=mean([sag(x,y,z) ax(x,y,z)]);
        end
    end
    disp(num2str(x))
end


%% %%
outputdir= spm_select(1,'dir','select directory to save surface');
dataOut=brain_info;

dataOut.fname='tmp.img';
spm_write_vol(dataOut,mm);


