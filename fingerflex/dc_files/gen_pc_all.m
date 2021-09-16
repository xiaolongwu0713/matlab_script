function gen_pc_all(subject)

load(['data/' subject '/' subject '_decoupled'],'pc_vecs','f')
load(['data/' subject '/' subject '_fingerflex'],'data'), data=car(data);
clear pc_weights


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %create indices to exclude around harmonics of 60
% f0=1:300; no60=[];
% for k=1:ceil(max(f0/60)), no60=[no60 (60*k-3):(60*k+3)]; end %3 hz up or down
% no60=[no60 247:253]; 
% f0=setdiff(f0,no60); %dispose of 60hz stuff
% f0(find(f0>200))=[];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f0=f;


lnA=0*data;

for chan=1:size(data,2)
    disp([subject ' channel ' num2str(chan) ' / ' num2str(size(data,2))])
    dt=data(:,chan); 
    mm=squeeze(pc_vecs(:,chan,:))';  %mixing matrix
    pcvec1=mm(:,1);  
    lnA(:,chan)=dg_tf_pwr_rm(dt,pcvec1,f0);
end

save(['data/' subject '/' subject '_pc_ts'],'lnA')
