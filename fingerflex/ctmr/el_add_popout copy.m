function el_add_popout(locs,elcol,msize,th,phi)
% function el_add_popout(locs,elcol,msize,th,phi)
% pops electrodes out in th, phi polar coords
% kjm 02/11


a_offset=.1*max(abs(locs(:,1)))*[cosd(th-90)*cosd(phi) sind(th-90)*cosd(phi) sind(phi)];

locs=locs+...
    repmat(a_offset,size(locs,1),1);


if ~exist('msize','var')
    msize=8; %marker size
end

if exist('elcol')==0, 
    elcol='r'; %default color if none input
end

hold on, plot3(locs(:,1),locs(:,2),locs(:,3),'.','Color', elcol,'MarkerSize',msize)

loc_view(th,phi)
