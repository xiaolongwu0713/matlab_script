function export_to_eeglab_event(trigger,session)
global processed_data
eventtable=[];
t=find(trigger);
for i=1:size(t,2)
    eventtable(i,1)=trigger(t(i));
    eventtable(i,2)=t(i); % 10*exp(-3) seconds
    eventtable(i,3)=0;
end
outputfilename=strcat(processed_data,'/eeglab/',num2str(session),'_eventtable.txt');
%writematrix(allevents,outputfilename,'Delimiter',' ')
dlmwrite(outputfilename,eventtable,'delimiter',' ','precision', '%.f'); % precision can avoid sci notion and %.f means no decimal

end