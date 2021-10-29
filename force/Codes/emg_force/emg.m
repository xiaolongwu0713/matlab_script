% emg_4=load('SYF_session4.mat');
% emg_4_trigger_stem=emg_4.Sig(65,:);
% emg_4=mean(emg_4.Sig(1:64,:)',2);
% emg_4_trigger=Force_Trigger_Check(emg_4_trigger_stem);

% emg_4_built=zeros(30000,40);
% for i=1:40
%     emg_4_built(:,i)=emg_4(emg_4_trigger(i):(emg_4_trigger(i)+30000-1));
% end


% OME=[20,500];
% AC=64;
% data=Sig(1:64,:)';
% Fs=2000;
% k=2;
% emg_4=cFilterD_EMG(data,AC,Fs,k,OME);

% emg_4_resized=zeros(30000,10,4);
% for i=1:4
%     for j=1:10
%         emg_4_resized(:,j,i)=emg_4_built(:,seq_4(i,j));
%     end
% end

emg_resized=zeros(30000,40,4);
emg_resized(:,1:10,1)=emg_1_resized(:,:,1);
emg_resized(:,11:20,1)=emg_2_resized(:,:,1);
emg_resized(:,21:30,1)=emg_3_resized(:,:,1);
emg_resized(:,31:40,1)=emg_4_resized(:,:,1);

emg_resized(:,1:10,2)=emg_1_resized(:,:,2);
emg_resized(:,11:20,2)=emg_2_resized(:,:,2);
emg_resized(:,21:30,2)=emg_3_resized(:,:,2);
emg_resized(:,31:40,2)=emg_4_resized(:,:,2);

emg_resized(:,1:10,3)=emg_1_resized(:,:,3);
emg_resized(:,11:20,3)=emg_2_resized(:,:,3);
emg_resized(:,21:30,3)=emg_3_resized(:,:,3);
emg_resized(:,31:40,3)=emg_4_resized(:,:,3);

emg_resized(:,1:10,4)=emg_1_resized(:,:,4);
emg_resized(:,11:20,4)=emg_2_resized(:,:,4);
emg_resized(:,21:30,4)=emg_3_resized(:,:,4);
emg_resized(:,31:40,4)=emg_4_resized(:,:,4);
