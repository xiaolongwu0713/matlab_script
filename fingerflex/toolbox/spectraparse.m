function spectraparse(patient,freq_bins,spectra,conditions)
% function spectraparse(patient,freq_bins,spectra,conditions)
% this function is to parse through frequency spectra in different channels
% for different conditions
% spectra should be in the form spectra(bins, channels, conditions)
% conditions should be a text array of conditions
% %dimensions use "k" to parse forward and "d" to parse back 
% %press "s" to save image, press "m" to mark it (vector spit out after)

channels=length(spectra(1,:,1));
currchan=1;
fp=figure;
marked=[];

%%%%%%%  output instructions %%%%%%%
disp(patient)
disp('press k to parse forward')
disp('press d to parse backward')
disp('press s to save image')
disp('press m to mark image')
disp('press q to quit')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


c='a';
while c~='q'
    %%%%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%%%%%
    clf
    plot(freq_bins,squeeze(spectra(:,currchan,:)))
    ylabel('power'),xlabel('frequency'),title(strcat([patient ' power spectra for channel ' num2str(currchan)]))
	legend(conditions,0)
    %%%%%%%%%%%%%%%%%%%%%%%advancing/parsing%%%%%%%%%%%%%%%%%
    waitforbuttonpress
    y=get(fp);
    c=y.CurrentCharacter;
    if c=='k'
        if currchan<channels %condition
            currchan=currchan+1; %action
        end
    elseif c=='d'
        if currchan>1 %condition
            currchan=currchan-1; %action
        end
    elseif c=='s'%save this picture
        exportfig(gcf, strcat(cd,'\resfiles\','pwr_',patient,'_',num2str(currchan),'_',num2str(min(freq_bins)),'_',num2str(max(freq_bins)),'.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
        exportfig(gcf, strcat(cd,'\resfiles\','pwr_',patient,'_',num2str(currchan),'_',num2str(min(freq_bins)),'_',num2str(max(freq_bins)),'.eps'), 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
    elseif c=='m'%mark this number
        marked=[marked currchan];
    end
end
close(fp)
marked=unique(marked)'
assignin('base', 'marked', marked)