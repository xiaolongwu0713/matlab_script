function [ electri ] = findTripointsDepth(cortex,elec,normdist)
%This script is used for finding the closet vertex within certain distance
% by liguangye.hust@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=cortex.vert;
N=length(M);
electri=[];
for i=1:length(elec)
    devectd=[];
    for v=1:N
        devect=M(v,:)-elec(i,:);
        devectd(v)=devect*devect';
    end
    [mindist,minind]=min(devectd);
    mindist=mindist(1);
    minind=minind(1);
    if mindist<normdist^2
        electri(i,:)=M(minind,:);
    else
        electri(i,:)=[nan,nan,nan];
    end
end
 

end

