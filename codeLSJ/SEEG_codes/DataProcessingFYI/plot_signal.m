function plot_signal(data,Chnnum,ChnName)
data=double(data);
meanval=mean(mean(abs(data(:,1:Chnnum))));
N=size(data,1);
str=cell(1,Chnnum);
for i=1:Chnnum
    data(:,i)=data(:,i)/2-2*repmat(5*(i-1)*meanval,N,1);
    str{i}=num2str(i);     
end
clf;
plot(data(:,1:Chnnum));
if nargin==2
text(repmat(N,1,Chnnum),mean(data(:,1:Chnnum)),str);
else
    text(repmat(N,1,Chnnum),mean(data(:,1:Chnnum)),{ChnName(1:Chnnum).labels},'fontsize',5);
axis('auto');
%  legend(str);
end