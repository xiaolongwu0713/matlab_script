xaxis=schemadata.xaxis; % 40 cells containing 5 points each
yaxis=schemadata.yaxis;

for i=1:10
    subplot(2,5,i);
    x=xaxis(i);
    y=yaxis(i);
    plot(x{1},y{1});
end

a=wgn(1,2000,1);
b1=wgn(1,1000,1);
b2=wgn(1,1000,1).*10;
b3=wgn(1,1000,1).*20;
r1=rsqu(a,b1);
r2=rsqu(a,b2);
r3=rsqu(a,b3);

[X,Y,Z] = peaks(25);
figure
surf(X,Y,Z);
view(2), shading interp
hold on
plot([-3 3],[-2 -2], 'k-')
plot3([-3 3],[0.25 0.25],[25 25], 'b-')
