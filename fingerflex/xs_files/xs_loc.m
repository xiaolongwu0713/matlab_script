function [mlocs,slocs]=xs_loc(subject,clims)
% function xs_loc(subject,clims)
% this function is to localize sites on an MR cross section from CT
% the CT must first be realigned and resliced into the MR
% kjm 12/11, revised 11/12

%% load CT
% disp('Getting CT'), clear handles.data; [ctName]=spm_select(1,'image'); ctStruct=spm_vol(ctName); % get the ct into a structure
ctStruct=spm_vol([cd '/brains/' subject '/r' subject '_ct.nii']); % get the ct into a structure - note that it must be named rxx_ct.nii
ctmat=spm_read_vols(ctStruct); % from structure to data matrix and xyz matrix (voxel coordinates)

%% load MR
mrStruct=spm_vol([cd '/brains/' subject '/' subject '_mri.nii']); % get the mri 
mrmat=spm_read_vols(mrStruct); % from structure to data matrix and xyz matrix (voxel coordinates)

%% get locs

%initialize
locs=[]; m_pos=[1 1]; k=15; kmax=size(ctmat,3); tq=1; key = 'n';

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
    
    end
    %
    clf, % render figure 
    % mri
    subplot('position',[0  0 .5 .9]), imagesc(squeeze(mrmat(:,:,k))'), colormap gray, axis equal, axis off, 
        set(gca,'clim',clims)
        if isempty(m_pos)~=1, hold on, plot(m_pos(1),m_pos(2),'m.'), end % candidate site
        if isempty(tlocs)~=1, 
            if isempty(aa)~=1, hold on, plot(tlocs(aa,1),tlocs(aa,2),'c.'), end
            if isempty(ab)~=1, hold on, plot(tlocs(ab,1),tlocs(ab,2),'g.'), end
            if isempty(ac)~=1, hold on, plot(tlocs(ac,1),tlocs(ac,2),'r.'), end
        end             
    % ct
    subplot('position',[.5 0 .5 .9]), imagesc(squeeze(ctmat(:,:,k))'), colormap gray, axis equal, axis off,    
        if isempty(m_pos)~=1, hold on, plot(m_pos(1),m_pos(2),'m.'), end % candidate site
        if isempty(tlocs)~=1, 
            if isempty(aa)~=1, hold on, plot(tlocs(aa,1),tlocs(aa,2),'c.'), end
            if isempty(ab)~=1, hold on, plot(tlocs(ab,1),tlocs(ab,2),'g.'), end
            if isempty(ac)~=1, hold on, plot(tlocs(ac,1),tlocs(ac,2),'r.'), end
        end    
    %
    title({['Click to get electrode ' num2str(size(locs,1)+1) ' position']; '"d" for down, "k" for up'; 'Press "y" to keep point, "q" to quit'})
    
    %% get event
    km=waitforbuttonpress; temp=get(gcf); temp2=get(gca);
    if km==0     %mouse
        m_pos=floor(temp2.CurrentPoint(1,1:2));
        key = 'n';
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end    
    
    %% responses
    if key == 'y', locs=[locs; [m_pos k]]; key ='n'; m_pos=[1 1];
    elseif key == 'k', if k<kmax, k=k+1; end
    elseif key == 'd', if k>1, k=k-1; end
    elseif key == 'q',  tq = 0; end
    
    clear a aa ab ac tlocs
    
end

close

%% transform to appropriate coordinates
    
    % locs as matrix indices
    mlocs=locs; 
    
    % locs in standardized coordinates
    slocs=0*locs;
    for k=1:3
        slocs(:,k)=(mrStruct.mat(k,1:3)*locs.').'+mrStruct.mat(k,4);
    end


%%
save(['brains/' subject '/' subject '_xslocs_tmp'], 'mlocs','slocs')

