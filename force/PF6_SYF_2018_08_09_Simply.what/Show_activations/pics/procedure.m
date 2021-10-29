viewvect={'front','top','isometric','left'};
for i=1:4
    figure
    cla;
set(gca, 'Color', 'none'); set(gcf, 'Color', 'w');
 viewBrain(cortexsmoothed,tala,{'brain'},1,32,viewvect(1));
saveas(gcf,['.\',num2str(i),'.bmp'])
end