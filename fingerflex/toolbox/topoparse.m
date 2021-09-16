function topoparse(fname,patient,ressq)
% %this function is to parse through (precalculated) frequencies
% %must first run through in the form res(channels,frequencies)- gerwin's
% normal - to generate called spectral datafile
% set up for 64 grid
% %dimensions use "k" to parse forward and "d" to parse back 
% %press "s" to save image
%  call as - topoparse(patient,paradigm)

load(fname)
freqs=length(freq_bins);
resname=ressq;
ressq=eval(ressq);
ressq=ressq(:,1:64);
currfreq=1;
fp=figure;
%%%%%%%  output instructions %%%%%%%
disp(patient)
disp('press k to parse forward')
disp('press d to parse backward')
disp('press s to save image')
disp('press q to quit')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c='a';
while c~='q'
    %%%%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%%%%%
    clf
%     subplot(1,3,1)
%     a=reshape(ressq(currfreq,:),8,8);     surf(a),view(2),colorbar
    eloc_file='kaiECoG64.txt';
    topoplot(ressq(currfreq,:), eloc_file, 'maplimits', [min(min(ressq)), max(max(ressq))], 'style', 'straight', 'interplimits', 'electrodes', 'headcolor', 'white');
    colorbar
 

	title(strcat([patient ', r^2 at ' num2str(freq_bins(currfreq)) ' (Hz) ' resname]))

    
    %%%%%%%%%%%%%%%%%%%%%%%advancing/parsing%%%%%%%%%%%%%%%%%
    waitforbuttonpress
    y=get(fp);
    c=y.CurrentCharacter;
    if c=='k'
        if currfreq<freqs %condition
            currfreq=currfreq+1; %action
        end
    elseif c=='d'
        if currfreq>1 %condition
            currfreq=currfreq-1; %action
        end
    elseif c=='s'%save this picture
        exportfig(gcf, strcat(cd,'\resfiles\','topo',patient,'_',num2str(freq_bins(currfreq)),'.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
        exportfig(gcf, strcat(cd,'\resfiles\','topo',patient,'_',num2str(freq_bins(currfreq)),'.eps'), 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
    end
end
close(fp)