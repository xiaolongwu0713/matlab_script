function [ tala ] = projectElectrodesDepthGrid(pathToSubjectDir,tala,handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
normdist=handles.normdist;
load(strcat(pathToSubjectDir,'/WholeCortex.mat'));
cortexcoarser_left = coarserModel(leftcortex, 10000);
cortexcoarser_right = coarserModel(rightcortex, 10000);
if handles.eleIndex==1
   cortexcoarser.tri=[cortexcoarser_left.tri;cortexcoarser_right.tri+size(cortexcoarser_left.vert,1)];
   cortexcoarser.vert=[cortexcoarser_left.vert;cortexcoarser_right.vert];
   tala.trielectrodes=findTripointsDepth(cortexcoarser,tala.electrodes,normdist);
elseif handles.eleIndex==2
cortex_convex_left = hullModel(cortexcoarser_left);
cortex_convex_right = hullModel(cortexcoarser_right);
cortex_convex.tri=[cortex_convex_left.tri;cortex_convex_right.tri+size(cortex_convex_left.vert,1)];
cortex_convex.vert=[cortex_convex_left.vert;cortex_convex_right.vert];
[ tala ] = projectElectrodes(cortex_convex, tala, normdist);
elseif handles.eleIndex==3
cortexcoarser.tri=[cortexcoarser_left.tri;cortexcoarser_right.tri+size(cortexcoarser_left.vert,1)];
cortexcoarser.vert=[cortexcoarser_left.vert;cortexcoarser_right.vert];
cortex_convex_left = hullModel(cortexcoarser_left);
cortex_convex_right = hullModel(cortexcoarser_right);
cortex_convex.tri=[cortex_convex_left.tri;cortex_convex_right.tri+size(cortex_convex_left.vert,1)];
cortex_convex.vert=[cortex_convex_left.vert;cortex_convex_right.vert];
selectrodes=tala.electrodes(1:tala.seeg_pos,:);
talae.electrodes=tala.electrodes(tala.seeg_pos+1:end,:);
selectrodestri=findTripointsDepth(cortexcoarser,selectrodes,normdist);
[ talae ] = projectElectrodes(cortex_convex,talae,normdist);
tala.trielectrodes=[selectrodestri;talae.trielectrodes];
else
    error('Wrong electrode type inputs,please check the electrodes index!');
end

end

