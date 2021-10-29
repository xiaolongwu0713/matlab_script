function rsq=rsqMove(data,type)
% calculate r_squared for one movement type epoch data. type=1/2/3/4;
% Input: data: 3D epoch.
channels=size(data,1);
trials=size(data,3);
len=size(data,2);
rsq=zeros(trials,channels);
if type==1
    ascendEnd=5;
elseif type==2
    ascendEnd=11;
elseif type==3
    ascendEnd=3;
elseif type==4
    ascendEnd=5;
end

for trial=[1:trials]
    tstart=2*1000;
    %tend=13.5*1000;
    tend=ascendEnd*1000; % looking at ascending stage
    task=data(:,tstart:tend,trial);
    baseline1=data(:,1:tstart-1,trial);
    baseline2=data(:,tend+1:len,trial);
    baseline=[baseline1,baseline2];
    for chn=[1:channels]
        rsq(trial,chn)=rsqu(task(chn,:),baseline1(chn,:));
    end
end
rsq=rsq';
end