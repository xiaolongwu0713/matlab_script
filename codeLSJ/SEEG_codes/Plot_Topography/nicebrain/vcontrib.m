function vcontribs = vcontrib(cortex,tala)
%%
wholecortex = load(fullfile(env.get('stdbrain'),'WholeCortex'),'leftcortex','rightcortex');
handles.eleIndex=1;
handles.normdist=25;
tala=projectElectrodesDepthGrid(wholecortex,tala,handles);
kernel = 'gaussian';
parameter = 10;
cutoff = 10;
Dis_surf=15;
%See also |electrodesContributions| for a more thorough information on its arguments)
[ vcontribs ] = electrodesContributions( cortex, tala, kernel, parameter, cutoff, Dis_surf);
% normalizing vcontribs by number of electrodes 
vcontribs_norm = vcontribs;
 
for idx=1:length(vcontribs),
    
    v_norm = sum(vcontribs(idx).contribs(:,3));
    
    if size(vcontribs(idx).contribs,1) > 1,
        
        vcontribs_norm(idx).contribs(:,3) = vcontribs(idx).contribs(:,3) ./ v_norm;
        
    end
end
vcontribs=vcontribs_norm;
S = matdoc('kernel',kernel,'param',parameter,'cutoff',cutoff,'Dis_surf',Dis_surf,...
    'comment','calculated for permanent usage');
save(fullfile(env.get('groupresult'),'TopoPlot','vcontribs'),'vcontribs');
end

