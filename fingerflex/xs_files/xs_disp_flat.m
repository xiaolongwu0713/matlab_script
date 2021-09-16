function xs_disp_flat(subject, locs, clims)
% function xs_disp(subject)
% this function is to display sites on an MR cross section 
% they must first have been localized using the "xs_loc" function
% the input "tlocs" should be in matrix coordinates, not in talairach / mni
% kjm 12/11

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
    %
    clf, % render figure 
    % mri
    subplot('position',[.05  .1 .8 .8]), 
    imagesc(squeeze(mrmat(:,:,k))'), colormap gray, axis equal, axis off, 
    hold on, plot(locs(:,1),tlocs(:,2),'r.'),
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


