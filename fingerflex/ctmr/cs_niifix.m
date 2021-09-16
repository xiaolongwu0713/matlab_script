function cs_niifix
% first we tried to convert with dcm2niigui - didn't work, but did give us 15 "partial" nii files
% so we have to work around
% cs, kjm 5/2011



%% subject specific defaults
%     fld1='ugtmp/'; % change for new subject
%     slcnum=14;  % number of error output slices
%     outputname = 'ug_ct.nii';

%     % zt
%     fld1='brains/zt/Recon2/'; % change for new subject
%     slcnum=14;  % number of error output slices
%     outputname = 'zt_ct.nii';

%     % ca
%     fld1='brains/ca/DrG_CT/'; % change for new subject
%     slcnum=14;  % number of error output slices
%     outputname = 'ca_ct.nii';

%     % ja
%     fld1='brains/ja/CT/'; % change for new subject
%     slcnum=15;  % number of error output slices
%     outputname = 'ja_ct.nii';

%     % mv
%     fld1='brains/mv/Recon2/'; % change for new subject
%     slcnum=14;  % number of error output slices
%     outputname = 'mv_ct.nii';    

%     % wc
%     fld1='brains/wc/wc_ct/'; % change for new subject
%     slcnum=15;  % number of error output slices
%     outputname = 'wc_ct.nii';   


    % hs
    fld1='nr/hs_preop_ct/'; % change for new subject
    slcnum=17;  % number of error output slices
    outputname = 'hs_preop_ct.nii';  

%%

bmat=[];

for k = 1:slcnum
    if k<10
        a=['a00' num2str(k) '.nii'];
    else
        a=['a0' num2str(k) '.nii'];   
    end
    
    %load mri
    binfo=spm_vol([fld1 a]); [b]=spm_read_vols(binfo);

    %smash together
    bmat=cat(3,bmat,b);
end


%% get our proper transformation matrix
    brain_info=spm_vol([fld1 'a001.nii']); % loads the bottom slice - proper transformation matrix 
    % modifications
    brain_info.fname = outputname;
    brain_info.dim=size(bmat);
    brain_info.private.dat.fname = outputname;
    brain_info.private.dat.dim=size(bmat);


%% output file

spm_write_vol(brain_info,bmat);



