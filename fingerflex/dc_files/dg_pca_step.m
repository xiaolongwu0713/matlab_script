function [pc_weights, pc_vecs, pc_vals, f]=dg_pca_step(patient,spectra)
%this function calculates and returns the principal spectra/eigenvalues, and their projections.
%it also returns the acceptable frequency range b/c of jc and cc
%kjm 12/07

nc=size(spectra,2);%number of channels left

% ncomps=2; %number of components to keep


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create indices to exclude around harmonics of 60
f=1:300; no60=[];
for k=1:ceil(max(f/60)), no60=[no60 (60*k-3):(60*k+3)]; end %3 hz up or down
no60=[no60 247:253]; 
f=setdiff(f,no60); %dispose of 60hz stuff
f(find(f>200))=[];
% if patient=='jc', f(find(f>195))=[]; f(find(and(f>97,f<103)))=[]; f(find(and(f>155,f<165)))=[]; f(find(and(f>53,f<67)))=[]; end
% if patient=='cc', f(find(f<5))=[]; end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncomps=length(f); %number of components to keep


%initialize
pc_weights=zeros(ncomps,nc,size(spectra,3)); %projection weights
pc_vecs=zeros(ncomps,nc,length(f)); %eigenvectors
pc_vals=zeros(ncomps,nc); %eigenvalues

%%run pca
for chan=1:nc
    %select proper data
    ts=squeeze(spectra(f,chan,:)); %introduce log?
    
    %get evecs and evals
    [vecs,vals]=eig(ts*ts'); 
    [vals,v_inds]=sort(sort(sum(vals)),'descend'); vecs=vecs(:,v_inds); %reshape properly

    
    %assign values
    pc_weights(:,chan,:)=vecs(:,1:ncomps)'*ts;
    pc_vecs(:,chan,:)=vecs(:,1:ncomps)';
    pc_vals(:,chan)=vals(1:ncomps);
    
    clear v_inds covmat vecs vals ts %housekeeping
end