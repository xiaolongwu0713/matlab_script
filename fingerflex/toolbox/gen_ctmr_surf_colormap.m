


r_width=16;
g_width=4;
g_width2=5;
b_width=8;
x0=16; %make smaller to move yellow closer to red
% yellow='y';
yellow='n'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=64:-1:1;
%
r=.3*exp(-x/r_width)+.7; 
%
if yellow=='y'
    g=.7*(1-exp(-x/g_width))+.3*exp((-(x-x0).^2)/(2*g_width2^2));
else
    g=.7*(1-exp(-x/g_width));
end
% 
b=.7*(1-exp(-x/b_width));

cm=[r' g' b'];
cm(find(cm>1))=1; cm(find(cm<0))=0;


clf, plot(r,'r'),hold on, plot(g,'g'),plot(b,'b'), colorbar, colormap(cm)


