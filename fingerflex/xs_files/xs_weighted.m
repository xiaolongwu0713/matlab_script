function xs_weighted(subject, locs, clims, wts)
% function xs_disp(subject)
% this function is to display sites on an MR cross section 
% they must first have been localized using the "xs_loc" function
% the input "locs" should be in mni - from CT that has already been co-registered to this MRI

% kjm 12/11


%% defaults
lcm=max(abs(wts));

%plotting threshold
if lcm>0, pthresh = .05*lcm;
else pthresh = 0; end


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
    %% render mri 
    clf, subplot('position',[.05  .1 .8 .8]), 
    imagesc(squeeze(mrmat(:,:,k))'), colormap gray, axis equal, axis off, set(gca,'clim',clims)
    title({'"d" for down, "k" for up';'"p" to print, "q" to quit'})
    
    %% plot weights
    for q=1:size(locs,1)% add activity colorscale
        if abs(locs(q,3)-k)<3 % plot only those near current slice
            if abs(wts(q))<pthresh % not significant
                % black circle
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',11.5,...
                'Color',.01*[1 1 1])  
                % gray inner
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',10,...
                'Color',.35*[1 1 1])  
                %
            elseif wts(q)>=pthresh
                % black circle
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/lcm+11.5,...
                'Color',.01*[1 1 1])
                % colored inner
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/lcm+10,...
                'Color',.99*[1 1-wts(q)/lcm 1-wts(q)/lcm])
                %
            elseif wts(q)<=(-pthresh)
                % black circle
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/lcm+11.5,...
                'Color',.01*[1 1 1])
                %
                hold on, plot(locs(q,1),locs(q,2),'.',...
                'MarkerSize',15*abs(wts(q))/lcm+10,...
                'Color',.99*[1+wts(q)/lcm 1+wts(q)/lcm 1])
            end
        end
    end

    %% get event
    km=waitforbuttonpress; temp=get(gcf); temp2=get(gca);
    if km==0, key = 'n'; %mouse
    elseif km==1, key=temp.CurrentCharacter; %key button
    end    
    
    %% responses
    if key == 'p',
        title([])
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


