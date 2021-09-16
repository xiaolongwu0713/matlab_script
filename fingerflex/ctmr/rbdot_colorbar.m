function rbdot_colorbar

%%

figure

lcm=20;

for k=20:-.25:0;
    hold on, plot(0,k,'.',...
        'MarkerSize',30*k/lcm+20,...
        'Color',.99*[1 1-k/lcm 1-k/lcm])
    
    hold on, plot(0,-k,'.',...
        'MarkerSize',30*k/lcm+20,...
        'Color',.99*[1-k/lcm 1-k/lcm 1])
        
end

for k=-.5:.2:.5
    hold on, plot(0,k,'.',...
        'MarkerSize',20,...
        'Color',.35*[1 1 1])    
end
    
axis off, set(gcf,'color','w')
    
    
    
    

