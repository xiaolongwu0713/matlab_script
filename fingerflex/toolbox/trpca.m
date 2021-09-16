function [trmat,trvecs,trvals]=trpca(V,events);

dp= 500; %del plus
dm= -100; %del minus
if dp<dm error('idiot','idiot'),end
ne=length(events); %number of events
nc=size(V,1); %number of channels
%V should be in chan x time

% figure
U=zeros(nc);

for l=1:(nc-1)
    disp(num2str(l))
    for m=(l+1):nc
        temp=0;
        for i=1:(ne-1)
            for j=(i+1):ne %no overlaps
                temp=temp+sum(V(l,(events(i)+dm):(events(i)+dp)).*V(m,(events(j)+dm):(events(j)+dp)));
            end
        end
        U(l,m)=temp/((ne^2-ne)/2*(dp-dm)); %careful normalization b/c no overlap
        U(m,l)=U(l,m); %symmetric
    end
%     imagesc(U),colorbar,pause(.2)
end


for m=1:nc
    temp=0;
        for i=1:(ne-1) 
            for j=(i+1):ne %no overlaps
                temp=temp+sum(V(m,(events(i)+dm):(events(i)+dp)).*V(m,(events(j)+dm):(events(j)+dp)));
            end
        end
        U(m,m)=temp/((ne^2-ne)/2*(dp-dm)); %careful normalization b/c no overlap
end

trmat=U;
[trvecs,trvals]=eig(trmat);
%need to reorder vectors and values
tempvecs=0*trvals;tempvals=zeros(1,length(trvecs(:,1)));
for i=1:length(trvecs(:,1))
    tempvecs(:,i)=trvecs(:,length(trvecs(:,1))+1-i);
    tempvals(i)=trvals(length(trvecs(:,1))+1-i,length(trvecs(:,1))+1-i);
end

