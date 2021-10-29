% load('force.mat');
%取最后50ms的数据的平均值作为替代
% force_1(1207800:1208000)=mean(force_1((1207800-100):1207800));
% force_2(1207800:1208000)=mean(force_2((1207800-100):1207800));
% force_3(1207800:1208000)=mean(force_3((1207800-100):1207800));
% force_4(1207800:1208000)=mean(force_4((1207800-100):1207800));
% trigger_force_1=triggerseeg_1-triggerseeg_1(1);
% trigger_force_2=triggerseeg_2-triggerseeg_2(1);
% trigger_force_3=triggerseeg_3-triggerseeg_3(1);
% trigger_force_4=triggerseeg_4-triggerseeg_4(1);
% 
% force_1_built=zeros(30000,40);
% for i=1:40
%     force_3_built(:,i)=force_3(trigger_force_3(i):(trigger_force_3(i)+30000-1));
% end

% emg_4_resized=zeros(30000,10,4);
% for i=1:4
%     for j=1:10
%         force_4_resized(:,j,i)=force_4_built(:,seq_4(i,j));
%     end
% end



force_resized=zeros(30000,40,4);
force_resized(:,1:10,1)=force_1_resized(:,:,1);
force_resized(:,11:20,1)=force_2_resized(:,:,1);
force_resized(:,21:30,1)=force_3_resized(:,:,1);
force_resized(:,31:40,1)=force_4_resized(:,:,1);

force_resized(:,1:10,2)=force_1_resized(:,:,2);
force_resized(:,11:20,2)=force_2_resized(:,:,2);
force_resized(:,21:30,2)=force_3_resized(:,:,2);
force_resized(:,31:40,2)=force_4_resized(:,:,2);

force_resized(:,1:10,3)=force_1_resized(:,:,3);
force_resized(:,11:20,3)=force_2_resized(:,:,3);
force_resized(:,21:30,3)=force_3_resized(:,:,3);
force_resized(:,31:40,3)=force_4_resized(:,:,3);

force_resized(:,1:10,4)=force_1_resized(:,:,4);
force_resized(:,11:20,4)=force_2_resized(:,:,4);
force_resized(:,21:30,4)=force_3_resized(:,:,4);
force_resized(:,31:40,4)=force_4_resized(:,:,4);






