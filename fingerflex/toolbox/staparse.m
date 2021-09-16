function staparse(filename)
% this function is to parse through sta in different channels
% for different conditions
% spectra should be in the form spectra(bins, channels, conditions)
% conditions should be a text array of conditions
% %dimensions use "k" to parse forward and "d" to parse back 
% %press "s" to save image, press "m" to mark it (vector spit out after)
stadir=strcat(cd,'\stafiles\');
load(strcat(stadir,filename))
ptname=filename;
if exist('patient')==0
    patient=ptname;
end

channels=length(sta(1,:,1));
currchan=1;
fp=figure;
marked=[];

c='a';
while c~='q'
    %%%%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%%%%%
    clf
    plot([-(before-1):after],mean(squeeze(sta(:,currchan,:)),3))
    ylabel('amplitude'),xlabel('datapoints'),title(strcat([patient ' stimulus triggered average for channel ' num2str(currchan)]))
	legend(labels,0)
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
        exportfig(gcf, strcat(cd,'\','sta_',patient,'_',num2str(currchan),'.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
        exportfig(gcf, strcat(cd,'\','sta_',patient,'_',num2str(currchan),'.eps'), 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
    elseif c=='m'%mark this number
        marked=[marked currchan];
    end
end
close(fp)
marked=unique(marked)'
assignin('base', 'marked', marked)