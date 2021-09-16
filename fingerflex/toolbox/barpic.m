function barpic(numbars)


a=zeros(900);
barwidth=floor(900/(2*numbars));
bar_ind=ceil([1:barwidth]-(barwidth/2));

for k=1:numbars
    a((2*k-1)*barwidth+bar_ind,:)=1;
end

a=1-a.';

%%
figure, subplot('position',[0 0 1 1]),
imagesc(a)
axis equal,
axis off
colormap gray
set(gcf,'color','w')
axis([1 900 1 900])


