function get_alt_colormap



% load('/Users/kai/toolbox/dg_pac/cm_alt.mat')

%%
figure
lcm=1
    for k=-1:.005:1
        if abs(k)<(.05*lcm)
            hold on, plot([k k],[-.025 .025],'-',...
            'Color',.35*[1 1 1])        
        elseif k>=(.05*lcm)
            hold on, plot([k k],[-.025 .025],'-',...
            'Color',.99*[1-k/lcm 1 1-k/lcm]) 
        elseif k<=(-.05*lcm)
            hold on, plot([k k],[-.025 .025],'-',...
            'Color',.99*[1 1+k/lcm 1]) 
        end
    end




