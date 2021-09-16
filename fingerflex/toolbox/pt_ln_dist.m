function d=pt_ln_dist(p0,p1,p2)
% function d=pt_ln_dist(p0,p1,p2)
% function d=pt_ln_dist([x0 y0],[x1 y1],[x2 y2])
% this function calculates the distance between the point {x0,y0} 
% and the line defined by points {x1,y1} and {x2,y2}



d=((p2(:,1)-p1(:,1)).*(p1(:,2)-p0(:,2))-(p1(:,1)-p0(:,1)).*(p2(:,2)-p1(:,2)))./((p2(:,1)-p1(:,1)).^2+(p2(:,2)-p1(:,2)).^2).^.5;
