function plv = kjm_plv(data1,f1,data2,f2)

% data1 = data for phase of frequency range f1
% data2 = data for amplitude of frequency range f2



dt1=hilbert(bp_filt(data1,f1)); % bp_filt would be a band-pass filtering function - I don't have any handy - my external isn't with me at the coffee shop i'm at
dt2=hilbert(bp_filt(data1,f2));

dt2p=hilbert(bp_filt(dt2,f1));


plv=mean(exp(1i*(angle(dt1)-angle(dt2p))));
%note - angle(plv) is the preferred phase of locking, abs(plv) is the PLV magnitude







