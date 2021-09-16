function kjm_printfig2(fname,ppsize)
% This function exports the current figure in a reasonable way, in both eps
% and png formats kjm 05/10
%
% "fname" - desired filename. include path if desired
% "size" - size of figure in cm





set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [ppsize]);


print(gcf,fname,'-depsc2','-r300','-painters', 'PaperUnits', 'centimeters', 'PaperSize', [ppsize]);
print(gcf,fname,'-dpng','-r300','-painters', 'PaperUnits', 'centimeters', 'PaperSize', [ppsize]);



