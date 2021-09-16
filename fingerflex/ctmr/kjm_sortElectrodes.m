function electrodes=kjm_sortElectrodes
% This is a torn-apart version of DHM's function sortElectrodes from her CTMR package.
%  Modify at will, use without guarantee
% kjm - modified for kjm style 4-2011 (note also that dh --> dhm)

%% load electrodes file - maybe switch to subject call instead of gui based load
    [data1.elecName]=spm_select(1,'image','select image with electrodes');
    data1.elecStruct=spm_vol(data1.elecName);
    data1.elec=spm_read_vols(data1.elecStruct); % from structure to data matrix 
    [x,y,z]=ind2sub(size(data1.elec),find(data1.elec>1.5));
    data1.elecXYZ=([x y z]*data1.elecStruct.mat(1:3,1:3)')+repmat(data1.elecStruct.mat(1:3,4),1,length(x))'; % from indices 2 native


%% make initial plot
    temp.X=data1.elecXYZ(:,1); temp.Y=data1.elecXYZ(:,2); temp.Z=data1.elecXYZ(:,3);
    fid = figure; plot3(temp.X,temp.Y,temp.Z,'.','MarkerSize',20); axis equal
    title({'Press enter to record each electrode position into variable.'; 'Press ''q'' and enter when finished:'})
    hold on; 
    h=datacursormode;
    set(h,'DisplayStyle','window');%,'SnapToData','on');
    axis equal

%% select electrodes
    elecNr=0; electrodes=[]; btquit = 'n';
    disp('Press enter to record each electrode position into variable.'), disp('Press ''q'' when finished:')
    %
    while btquit~='q'  %elecNr<totalnrElec
%         fprintf(1, 'select electrode %d\r', num2str(elecNr+1));
%         disp(['select electrode ' int2str(elecNr+1) ' position']),
        figure(fid) %return to figure
        next_el=input(['select electrode ' int2str(elecNr+1) ' position: '],'s');         % temp=get(fid);btquit=temp.CurrentCharacter; % old way of doing it
        figure(fid) %return to figure
        if isempty(next_el) % pressed enter             
            info_struct = getCursorInfo(h);
            elecNr=elecNr+1; electrodes=[electrodes; info_struct.Position];
            disp(['electrode ' int2str(elecNr) ' position ' int2str(electrodes(elecNr,:))]);
            text(info_struct.Position(1)*1.01,info_struct.Position(2)*1.01,info_struct.Position(3)*1.01,num2str(elecNr),'FontSize',12,'HorizontalAlignment','center','VerticalAlignment','middle')
            title({['Press enter to record the position of electrode ' num2str(elecNr+1)]; 'Press q and enter when finished:'})
        figure(fid) %return to figure
        elseif next_el == 'q',btquit = 'q';
        end
    end

%% save data
    save('loc_temp','electrodes');