f=1:150;
p1=1./f.^2.3;
p2=1./f.^2.0;
g1=.3*exp(-((f-20).^2)/70);
g2=.15*exp(-((f-5).^2)/30);
g=g1+g2;
n=.0002*exp(-((f-60).^2)/10);
figure, plot(log(g),'b', 'LineWidth', [2]), hold on, plot(log(g2+.01*g1),'r', 'LineWidth', [2])
figure, plot(log(n),'k', 'LineWidth', [2])
figure, plot(log(p1),'b', 'LineWidth', [2]), hold on, plot(log(p2),'r', 'LineWidth', [2])
exportfig(gcf,strcat('temp1.png'), 'format', 'png', 'Renderer', 'zbuffer', 'Color', 'cmyk', 'Resolution', 1200, 'Width', 3, 'Height', 2);
figure, plot(g,'b', 'LineWidth', [2]), hold on, plot(g2+.01*g1,'r', 'LineWidth', [2])
exportfig(gcf,strcat('temp2.png'), 'format', 'png', 'Renderer', 'zbuffer', 'Color', 'cmyk', 'Resolution', 1200, 'Width', 3, 'Height', 2);
figure, plot(n,'k', 'LineWidth', [2])
figure, plot(p1,'b', 'LineWidth', [2]), hold on, plot(p2,'r', 'LineWidth', [2])

figure, plot(log(p2+n+g2+.01*g1),'r', 'LineWidth', [2]),hold on,plot(log(g+n+p1),'b','LineWidth', [2]), axis tight
exportfig(gcf,strcat('temp3.png'), 'format', 'png', 'Renderer', 'zbuffer', 'Color', 'cmyk', 'Resolution', 1200, 'Width', 3, 'Height', 2);
