
set(0,'DefaultFigureVisible','off');

Folder=strcat('/Volumes/Samsung_T5/data/ruijin/gonogo/preprocessing/P',num2str(5));
figure(1)
x=[1:500];
y=2*x;
for chn = [1:20]
    plot(x,y)
    filename=strcat(Folder,'/analysis/','del',num2str(chn),'_v4.pdf');
    saveas(gcf,filename);
    clf('reset');
    close all;
end

set(0,'DefaultFigureVisible','on');