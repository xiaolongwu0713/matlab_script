function both=split_good_bad_channels(data, session, fs, para)
% data: dimmension: channel last
global processed_data;
good_channels= remove_bad_channels(data,fs,para);
channel_num=size(data,2);
bad_channels= setdiff(1:channel_num, good_channels); 
%filename=strcat(processed_data,'SEEG_Data/','PF6_F_SEEG_',num2str(session),'_good','.mat');
%save(filename, 'good');
%filename=strcat(processed_data,'SEEG_Data/','PF6_F_SEEG_',num2str(session),'_bad','.mat');
%save(filename, 'bad');
both.goodChannel=good_channels;
both.badChannel=bad_channels;

end