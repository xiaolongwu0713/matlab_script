function el_add(els,elcol,msize)
%kjm 08/06

if ~exist('msize','var')
    msize=8; %marker size
end

if exist('elcol')==0, 
    elcol='r'; %default color if none input
end

hold on, plot3(els(:,1),els(:,2),els(:,3),'.','Color', elcol,'MarkerSize',msize)

