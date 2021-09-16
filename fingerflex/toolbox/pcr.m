function dataout=pcr(data)
% this function regresses out the first moment 
% in the timeseries in an array of data
% e.g. "principal component re-referencing"
% kjm 5/2011

    data = double(data);

%% preliminary stuff
    % transpose if inappropriate
        if size(data,2)>size(data,1),
            data=data.';
        end
    
%% calculate covariance matrix
    Cmat=cov(double(data));
        
%% decomposition - eigenvectors are *columns* of vecs matrxi

    %get evecs and evals
    [vecs,vals]=eig(Cmat); 
    [vals,v_inds]=sort(sort(sum(abs(vals))),'descend'); vecs=vecs(:,v_inds); %reshape properly


    
%%    
    pcs = data*vecs;
    clear data
    pcs(:,1)=0;

%%

    dataout=pcs*pinv(vecs);

