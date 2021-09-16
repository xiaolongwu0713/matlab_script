

function kjm_imagesc_lines(x,y,z,cm, cscale, w_lines)
% this function plots imagesc like it should work. fo sho.
% also adds lines in y at each element of 'w_lines'


if exist('z')~=1, z=x; x=1:size(z,1); y=1:size(z,2); end

z=z.';
z=z(size(z,1):-1:1,:); 

if min(y)==1, y=[0 y]; end

imagesc(x,y,z)

hold on, 
if exist('w_lines')
    for k = 1: length(w_lines)
        plot(get(gca,'xlim'), max(y)-[w_lines(k) w_lines(k)], 'color', .99*[1 1 1],'linewidth',1.5)
    end
end

set(gca,'clim', cscale*[-1 1]),
colormap(cm), 



 a=get(gca,'yticklabel'); set(gca,'yticklabel',a(end:-1:1,:))
 set(gca,'xtick',pi*[-1:.5:1],'xticklabel',{'-p','-p/2','0','p/2','p'})

