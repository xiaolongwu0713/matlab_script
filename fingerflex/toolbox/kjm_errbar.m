function kjm_errbar(x,y,u,l,bcol,ecol)
% this function plots vertical barplots with errorbars
%
% it expects:
%     x - the number on the horizontal ordinate
%     y - the value at ordinate x (usually a mean) (with colors bcol)
%     u - the upper error at ordinate x (must be >0, takes abs val)
%     l - the lower error at ordinate x (must be >0) - upper error by default if not defined
%     bcol - bar colors (length(x) by [r g b])
%            if only 1 row, then that used for all
%            all gray by default
%     ecol - error line colors (rgb), black by default
%
% kjm 2/2010, 3/2013


% default gray bars and black lines
if exist('l')~=1, l=u; end 

% default gray bars and black lines
if exist('ecol')~=1, ecol=  zeros(length(x),3); end 
if exist('bcol')~=1, bcol=.5*ones(length(x),3); end

% expand bcol, ecol if only 1 color
if size(bcol,1)==1, bcol=ones(length(x),1)*bcol; end
if size(ecol,1)==1, ecol=ones(length(x),1)*ecol; end

% bar width
if numel(x)>1, barwid=min(diff(x))*.75; else, barwid=.75; end

% absolute vals
u=abs(u); l=abs(l);

for k=1:length(x)
    hold on
    bar(x(k),y(k),barwid,'FaceColor',bcol(k,:),'LineStyle','none'),
    plot([x(k)-barwid/6 x(k)+barwid/6],[y(k)+u(k) y(k)+u(k)],'-','Color',ecol(k,:))
    plot([x(k)-barwid/6 x(k)+barwid/6],[y(k)-l(k) y(k)-l(k)],'-','Color',ecol(k,:))
    plot([x(k) x(k)],[y(k)-l(k) y(k)+u(k)],'-','Color',ecol(k,:))
end
    
    