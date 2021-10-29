function convertDaqToMat(sid)
for i=1:4
    filename=strcat('/Volumes/Samsung_T5/seegData/PF',num2str(sid),'/Force_Data/',num2str(i),'-',num2str(i+1),'.daq');
    f = fopen(fullfile(filename));
    data = fread(f,'double'); %(6039000,1)
    savefile=strcat('/Volumes/Samsung_T5/seegData/PF',num2str(sid),'/Force_Data/',num2str(i),'-',num2str(i+1),'.mat');
    save(savefile,'data');
end
end