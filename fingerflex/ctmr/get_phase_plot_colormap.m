function get_phase_plot_colormap



% load('/Users/kai/toolbox/dg_pac/cm_alt.mat')
load cm3


%%
figure
for k=1:256
    for q=.05:.05:1
        hold on, plot([k k],q+[-.025 .025],'-','Color',1-q*(1-cm(k,:)))
    end
end
axis off

