function [ output_args ] = plotSpehereElecinBrain( cortex,pos,activations )
%plot the Spheric electrodes inside the brain compared to activation
%projection
%cortex, 
%activation
%tala, struct with field: pos, name,
%Name-value: 'color','on';
%           ' colorregion',vector
%           'hemiNo',1/2
load(fullfile(env.get('groupresult'),'Etala'),'difr2_time');
load(fullfile(env.get('groupresult'),'Etala'),'electrodes');
electrodes(:,1) = abs(electrodes(:,1));
area = {'precentral','postcentral','superiorparietal','supramarginal','middletemporal'};
areachnidx = area2chnidx('individual',area);
elecColor = zeros(length(electrodes),3);%black
cmap = brewermap(length(area),'set1');
for i=1:length(area)
    elecColor(areachnidx{i},:) = repmat(cmap(i,:),length(areachnidx{i}),1);
end
R = reshape(robustmapminmax((difr2_time(:)),1,0.4,2.5),2822,6);
%%
% load(fullfile(env.get('stdbrain'),'Norm_Brain'));
% colormap bone;
%load(fullfile(env.get('stdbrain'),'Cortex_Center_aparc'));
[areavertex,vertNo] = areavert(area);
Color_Cindex=repmat([0.9,0.9,0.9],length(cortex.vert),1);
for i=1:length(area)
Color_Cindex(areavertex{i},:) = repmat(cmap(i,:),length(areavertex{i}),1);
end
%%
for j=1:6
    figure,
hh = trisurf(cortex.tri,cortex.vert(:,1),cortex.vert(:,2),cortex.vert(:,3), 'FaceVertexCData',...
    Color_Cindex, ...
    'FaceColor', 'interp', 'CDataMapping', 'direct', 'linestyle', 'none','FaceAlpha',0.1);
set(hh,'FaceLighting','phong','AmbientStrength',0.5);
material('dull');
viewstruct.viewvect = [110, 10];
viewstruct.lightpos = [150, 0, 0];
view(viewstruct.viewvect);
light('Position', viewstruct.lightpos, 'Style', 'infinite');
axis equal;
idxtmp = cat(1,areachnidx{:});
hold on,plotBalls(electrodes(idxtmp,:),elecColor(idxtmp,:),R(idxtmp,j));
set(gca,'CameraPosition',1e+3*[1.198 0.417 0.239]);
end
end

