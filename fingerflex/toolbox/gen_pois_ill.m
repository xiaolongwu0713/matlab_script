a=rand(100,10000);
a(:,5001:10000)=a(:,5001:10000)/5;
a=(a<.015);
subplot(2,1,1), imagesc(1-a), colormap('gray')
axis off, set(gcf,'Color','w')
ylabel('Neurons'), xlabel('Spikes')

b=rand(100,10000);
for k=1:100
    b(k,:)=b(k,:).*((1-.5*sin(2*pi*[1:10000]/1000)).^2);
end
b(:,5001:10000)=b(:,5001:10000)*3;
b=(b<.05);

subplot(2,1,2), imagesc(1-b), colormap('gray')
axis off, set(gcf,'Color','w')


b=sum(a,1);
c=psd(b,1000,1000,500);

x=0:200;
d=x.*exp(-(x-3)/5);
e=0*a;

for k=1:100
    u=conv(a(k,:),d);
    u([1:99 (length(u)-100):length(u)])=[];
    e(k,:)=u;
end

f=sum(e,1);
g=cumsum(f);
h=psd(f,1000,1000,500);

figure, loglog(h)
figure, plot(log10(100:301),log10(h(100:301)))


