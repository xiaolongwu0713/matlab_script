function kjm_errbar_grps(gmeans,uerrs,lerrs)

% this function creates grouped errorbars with default colormaps
% based upon input matrices:
% gmeans - groups and bar height values (value by group)
% uerrs - upper errors (group by error) - must be > 0, takes abs
% lerrs - lower errors (group by error)
%
% kjm 2/2010


ngrp=size(gmeans,2);
nvals=size(gmeans,1);

cmaps=[...
    ([0:(nvals-1)]/(nvals-1))'... 
    (1-[0:(nvals-1)]/(nvals-1))'...
    1-2*abs((1-[0:(nvals-1)]/(nvals-1))'-.5)... 
    ];

x=[]; y=[]; bcol=[]; u=[]; l=[];

for k=1:ngrp
    x=[x; k-.35+([1:nvals]'/(nvals*1.3))];
    y=[y; gmeans(:,k)]; u=[u; uerrs(:,k)]; l=[l; lerrs(:,k)];
    bcol=[bcol; cmaps];
end
    
 kjm_errbar(x,y,u,l,bcol)    
    




