%% Merge force and trigger by movement type
fs=1000;
Info=load_data(9999,'info');
aNum=1.5;
f1=zeros();
f2=zeros();
f3=zeros();
f4=zeros();
trigger1=zeros();
trigger2=zeros();
trigger3=zeros();
trigger4=zeros();
for type=[1:4]
    forceraw=load_data(type,'force');
    x = 2:2:length(forceraw);
    force = forceraw(x);
    time = forceraw(x-1);
    force = force-min(force);
    ffs=double(length(time)/time(end)); %5000
    force=resample(force,fs,5000);

    
    trigger=Info(type).trigger;
    force(end:length(trigger))=0;% padding force to keep the same length as trigger
    begint=find(trigger,1); % 28207
    triggers=trigger(begint:end); % trigger shifted
    lastone=find(triggers,1, 'last'); %617125
    triggers(lastone+15000)=aNum; % extend another trigger point
    %subplot(2,1,1); plot(trigger); subplot(2,1,2);plot(triggers); 
    plot(triggers);hold on; plot(force);
    allindex=find(triggers);
    commonMarker=zeros(1,length(triggers));
    commonMarker(allindex)=aNum;
    for p=[1:4] % 4 protopy
        indexbegin=find(triggers==p); % 10 trial
        for i=[1:10]
            inin=find(allindex==indexbegin(i));
            indexend(i)=allindex(inin+1);
        end
        if p==1
            for i=[1:10]
                tmp1=force(indexbegin(i):indexend(i)-1);
                tmp2=commonMarker(indexbegin(i):indexend(i)-1);
                f1=[f1,tmp1'];
                trigger1=[trigger1,tmp2];
            end
        elseif p==2
            for i=[1:10]
                tmp1=force(indexbegin(i):indexend(i)-1);
                tmp2=commonMarker(indexbegin(i):indexend(i)-1);
                f2=[f2,tmp1'];
                trigger2=[trigger2,tmp2];
            end
         elseif p==3
            for i=[1:10]
                tmp1=force(indexbegin(i):indexend(i)-1);
                tmp2=commonMarker(indexbegin(i):indexend(i)-1);
                f3=[f3,tmp1'];
                trigger3=[trigger3,tmp2];
            end
        elseif p==4
            for i=[1:10]
                tmp1=force(indexbegin(i):indexend(i)-1);
                tmp2=commonMarker(indexbegin(i):indexend(i)-1);
                f4=[f4,tmp1'];
                trigger4=[trigger4,tmp2];
            end
        end
        clear  indexbegin indexend;
    end
end
% add a last trigger point
lastone=find(trigger1,1, 'last');
trigger1(lastone+15000)=aNum;
lastone=find(trigger2,1, 'last');
trigger2(lastone+15000)=aNum;
lastone=find(trigger3,1, 'last');
trigger3(lastone+15000)=aNum;
lastone=find(trigger4,1, 'last');
trigger4(lastone+15000)=aNum;
subplot(4,1,1);plot(f1);hold on; plot(trigger1);
subplot(4,1,2);plot(f2);hold on; plot(trigger2);
subplot(4,1,3);plot(f3);hold on; plot(trigger3);
subplot(4,1,4);plot(f4);hold on; plot(trigger4);

% padding force to be the same length
l1=length(f1);
l2=length(f2);
l3=length(f3);
l4=length(f4);
mlen=max([l1,l2,l3,l4]);
if l1<mlen
    paddingzeros=zeros(1,mlen-l1);
    f1=[f1,paddingzeros];
end
if l2<mlen
    paddingzeros=zeros(1,mlen-l2);
    f2=[f2,paddingzeros];
end
if l3<mlen
    paddingzeros=zeros(1,mlen-l3);
    f3=[f3,paddingzeros];
end
if l4<mlen
    paddingzeros=zeros(1,mlen-l4);
    f4=[f4,paddingzeros];
end

move1{1}=f1;move1{2}=trigger1;
move2{1}=f2;move2{2}=trigger2;
move3{1}=f3;move3{2}=trigger3;
move4{1}=f4;move4{2}=trigger4;
allforce{1}=move1;
allforce{2}=move2;
allforce{3}=move3;
allforce{4}=move4;
filename=strcat(processed_data,'Force_Data/allForce1D.mat');
save(filename,'allforce');
% unpack: see load_data.m


%% segment by trials
clear trigger force;
for type=[1:4]
    forcetype=strcat('force',num2str(type));
    ld=load_data(999,forcetype);
    f{type}=ld.force; 
    trigger{type}=ld.trigger;
end

% get the max length
for type=[1:4]
    mark{type}=find(trigger{type});
    marklens=mark{type}(2:end)-mark{type}(1:end-1)+1;
    markMlen(type)=max(marklens); %15112
end
mlen=max(markMlen);

force{1}=zeros(mlen,40);
force{2}=zeros(mlen,40);
force{3}=zeros(mlen,40);
force{4}=zeros(mlen,40);

for type=[1:4]
    for trial=[1:40]
        mark{type}=find(trigger{type});
        tmp=f{type}(mark{type}(trial):mark{type}(trial+1));
        tmplen=length(tmp);
        padding=zeros(mlen-tmplen,1);
        paddingTmp=[tmp';padding];
        force{type}(:,trial)=paddingTmp;
    end
end

subplot(2,2,1);plot(force{1}(:,6));subplot(2,2,2);plot(force{1}(:,7));subplot(2,2,3);plot(force{1}(:,8));subplot(2,2,4);plot(force{1}(:,9));

filename=strcat(processed_data,'Force_Data/allForce2D.mat');
save(filename,'force');
