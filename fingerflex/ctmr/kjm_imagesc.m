function kjm_imagesc(x,y,z)
% this function plots imagesc like it should work. fo sho.
% error('a','a')
if exist('z')~=1, z=x; x=1:size(z,1); y=1:size(z,2); end

z=z.';
z=z(size(z,1):-1:1,:); 

if min(y)==1, y=[0 y]; end

imagesc(x,y,z)

 a=get(gca,'yticklabel'); set(gca,'yticklabel',a(end:-1:1,:))



