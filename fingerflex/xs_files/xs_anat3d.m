function elcode=xs_anat3d(subject, locs, clims)
% function xs_disp(subject)
% this function is to display sites on an MR cross section 
% they must first have been localized using the "xs_loc" function
% the input "locs" should be in mni - from CT that has already been co-registered to this MRI
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
kmax=size(mrmat,3); 
elcode=[];

for q=1:size(locs,1)
tq=1; key = 'n';k=locs(q,3);
while tq~=0 % 
    %%
    
    cloc=locs(q,:);
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
    % mri - axial
    subplot('position',[.05  .5 .45 .45]), 
    imagesc(squeeze(mrmat(:,:,k))'), colormap gray, axis equal, axis off, 
        set(gca,'clim',clims)
        if isempty(tlocs)~=1, 
            if isempty(aa)~=1, hold on, plot(tlocs(aa,1),tlocs(aa,2),'c.'), end
            if isempty(ab)~=1, hold on, plot(tlocs(ab,1),tlocs(ab,2),'g.'), end
            if isempty(ac)~=1, hold on, plot(tlocs(ac,1),tlocs(ac,2),'r.'), end
        end             
        hold on, plot(cloc(1),cloc(2),'yo')
    %
    % mri - saggital
    subplot('position',[.5  .5 .45 .45]), 
    imagesc(squeeze(mrmat(cloc(1),:,:))), colormap gray, axis off, % axis equal, 
        set(gca,'clim',clims)      
        hold on, plot(cloc(3),cloc(2),'yo'), plot(cloc(3),cloc(2),'r.')     

    % mri - coronal
    subplot('position',[.05  .05 .45 .45]), 
    imagesc(squeeze(mrmat(:,cloc(2),:))), colormap gray, axis off,  % axis equal, 
        set(gca,'clim',clims)      
        hold on, plot(cloc(3),cloc(1),'yo'), plot(cloc(3),cloc(1),'r.')    
    subplot('position',[.75  .25 .05 .05]),plot(1,1,'w.'),axis equal, axis off
    title({['Electrode #' num2str(q)];'"d" for down, "k" for up';'press anatomy code to advance, "x" is null'})
    
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
    % codes for individual areas        
    elseif key == '1', elcode=[elcode; 1]; tq = 0; % Temporal pole
    elseif key == '2', elcode=[elcode; 2]; tq = 0; %Parahippocampal gyrus, parahippocampal part of the medial occipito-temporal gyrus
    elseif key == '3', elcode=[elcode; 3]; tq = 0; %Inferior temporal gyrus
    elseif key == '4', elcode=[elcode; 4]; tq = 0; %Middle temporal gyrus
    elseif key == '5', elcode=[elcode; 5]; tq = 0; %Lateral occipito-temporal gyrus, fusiform gyrus
    elseif key == '6', elcode=[elcode; 6]; tq = 0; %Lingual gyrus, lingual part of  the medial occipito-temporal gyrus
    elseif key == '7', elcode=[elcode; 7]; tq = 0; %Inferior occipital gyrus
    elseif key == '8', elcode=[elcode; 8]; tq = 0; %Cuneus
    elseif key == '9', elcode=[elcode; 9]; tq = 0; %Posterior-dorsal part of the cingulate gyrus
    elseif key == '0', elcode=[elcode; 10]; tq = 0; %Middle Occipital gyrus
    elseif key == 'a', elcode=[elcode; 11]; tq = 0; % occipital pole
    elseif key == 'b', elcode=[elcode; 12]; tq = 0; %precuneus
    elseif key == 'c', elcode=[elcode; 13]; tq = 0; %Superior occipital gyrus
    elseif key == 'e', elcode=[elcode; 14]; tq = 0; %Posterior-dorsal part of the cingulate gyrus
    elseif key == 'x', elcode=[elcode; 20]; tq = 0; %Non-included area
    end
    
    clear a aa ab ac 
    
end
end

close


