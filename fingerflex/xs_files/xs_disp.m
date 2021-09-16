function xs_disp(subject, locs, clims)
% function xs_disp(subject)
% this function is to display sites on an MR cross section 
% they must first have been localized using the "xs_loc" function
% the input "locs" should be in matrix coordinates, not in talairach / mni
% it calls the SPM function spm_vol to read the brain file in nifti format
% kjm 12/11

%% convert from mni to indices
locs=mni2vox(locs,subject);

%% load MR
mrStruct=spm_vol([cd '/brains/' subject '/' subject '_mri.nii']); % get the mri 
mrmat=spm_read_vols(mrStruct); % from structure to data matrix and xyz matrix (voxel coordinates)

% convert to appropriate orientation
mrmat=mrmat(:,end:-1:1,:);
locs(:,2)=size(mrmat,2)-locs(:,2);

%% display
k=8; kmax=size(mrmat,3); tq=1; key = 'n';
while tq~=0 % 
    %%
    tlocs=locs;
    if isempty(tlocs)~=1, 
        % get rid of far away electrodes
        a=find(tlocs(:,3)<(k-2)); a=[a; find(tlocs(:,3)>(k+2))]; tlocs(a,:)=[]; 
        % existing electrodes
        aa = find(tlocs(:,3)<k); % above current slice
        ab = find(tlocs(:,3)>k); % below current slice
        ac = find(tlocs(:,3)==k); % centered on current slice
    else
        disp('tlocs cleared')
    
    end
    %
    clf, % render figure 
    % mri
    subplot('position',[.05  .1 .8 .8]), 
    imagesc(squeeze(mrmat(:,:,k))'), colormap gray, axis equal, axis off, 
        set(gca,'clim',clims)
        if isempty(tlocs)~=1, 
            if isempty(aa)~=1, hold on, plot(tlocs(aa,1),tlocs(aa,2),'c.'), end
            if isempty(ab)~=1, hold on, plot(tlocs(ab,1),tlocs(ab,2),'g.'), end
            if isempty(ac)~=1, hold on, plot(tlocs(ac,1),tlocs(ac,2),'r.'), end
        end             
    %
    title({'"d" for down, "k" for up';'"p" to print, "q" to quit'})
    
    %% get event
    km=waitforbuttonpress; temp=get(gcf); temp2=get(gca);
    if km==0     %mouse
        key = 'n';
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end    
    
    %% responses
    if key == 'p',
        title(' ')
        fname=[subject '_slice_' num2str(k)];
        ppsize=10*[1 1];
        set(gcf, 'PaperUnits', 'centimeters'); set(gcf, 'PaperSize', [ppsize]); set(gcf, 'PaperPosition',[0 0 2*ppsize])
        print(gcf,fname,'-depsc2','-r300','-painters'); print(gcf,fname,'-dpng','-r300','-painters')
    elseif key == 'k', if k<kmax, k=k+1; end
    elseif key == 'd', if k>1, k=k-1; end
    elseif key == 'q',  tq = 0; 
    end
    
    clear a aa ab ac 
    
end

close


