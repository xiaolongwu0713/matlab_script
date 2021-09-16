function get_somato_stats(subject, band)


%%
    addpath /Users/kai/toolbox/
    addpath /Users/kai/toolbox/ctmr

%%
    load(['data/' subject '/' subject '_fband_' num2str(band(1)) '_' num2str(band(2))],'*block*','pts','*type*','dz_*','tr_sc'), 
    [lnA_r, lnA_p, lnA_m, lnA_s, rhy_r, rhy_p, rhy_m, rhy_s, Zmd_r, Zmd_p, Zmd_m, Zmd_s]=dg_block_stats(lnA_blocks, rhythm_blocks, dz_dist, tr_sc, beh_types, baseline_type);


%%
dtypes = [1 2 5];
%
for k=1:2
    % broadband shift with activity
    dtype1=dtypes(k);
    dl1=lnA_r(:,dtype1);
    dr1=rhy_r(:,dtype1);
    %
    for q=(k+1):3
        dtype2=dtypes(q);
        dl2=lnA_r(:,dtype2);
        dr2=rhy_r(:,dtype2);
        %
        disp('lnA')
        [OL_pct(2,k+q-2), OLM(2,k+q-2), p_val(2,k+q-2), rs_kurt(2,k+q-2)]=spat_reshuffle(dl1,dl2);
        disp('rhy')
        [OL_pct(1,k+q-2), OLM(1,k+q-2), p_val(1,k+q-2), rs_kurt(1,k+q-2)]=spat_reshuffle(dr1,dr2);        
    end
end

save(['data/' subject '/' subject '_' num2str(band(1)) '_' num2str(band(2)) '_OLstats'], 'OL_pct','OLM','p_val','rs_kurt')
