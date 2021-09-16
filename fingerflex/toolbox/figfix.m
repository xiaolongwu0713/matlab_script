function figfix
%here is where you change all of the parameters, figures, etc. etc.
fs=14;
fn='Times';
% fn='Courier';
% fn='Palatino';
% fn='Bookman';

set(gcf,'Color',[1 1 1]), 
set(gca,'FontName',fn,'FontSize',fs)

dd=get(gca);
set(dd.XLabel,'FontName',fn,'FontSize',fs)
set(dd.YLabel,'FontName',fn,'FontSize',fs)
set(dd.Title, 'FontName',fn,'FontSize',fs)
