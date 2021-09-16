function gs=ctmr_tmpsweep(k)
% take care of anisotropy



%% sweep in z

a=reshape(k(:,:,floor(size(k,3)/2)),1,[]);a(a==0)=[];
sf=mean(a);


gs=k;

for m=1:size(gs,3)
    a=reshape(k(:,:,m),1,[]);a(a==0)=[];
    if size(a)>4
    tf=mean(a);
    gs(:,:,m)=gs(:,:,m)*sf/tf;
    end
end
    

%% sweep in x

a=reshape(k(floor(size(k,1)/2),:,:),1,[]);a(a==0)=[];
sf=mean(a);


gs=k;

for m=1:size(gs,3)
    a=reshape(k(m,:,:),1,[]);a(a==0)=[];
    if size(a)>4
    tf=mean(a);
    gs(m,:,:)=gs(m,:,:)*sf/tf;
    end
end
    




