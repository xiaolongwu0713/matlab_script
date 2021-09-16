function matparse(mat)
% this function is to parse through the rows of a matrix
channels=length(mat(:,1));
currchan=1;
fp=figure;
marked=[];

c='a';
while c~='q'
    %%%%%%%%%%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%%%%%%%%%
    clf
    plot(mat(currchan,:))
    ylabel('amplitude'),xlabel('column datapoints'),title(strcat(['column ' num2str(currchan)]))
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
        exportfig(gcf, strcat(cd,'\','temp_c_',num2str(currchan),'.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
        exportfig(gcf, strcat(cd,'\','temp_c_',num2str(currchan),'.eps'), 'format', 'eps', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 600, 'Width', 3, 'Height', 3); 
    elseif c=='m'%mark this number
        marked=[marked currchan];
    end
end
close(fp)
marked=unique(marked)'
assignin('base', 'marked', marked)