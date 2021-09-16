function [b, a] = getButterFilter(band, sampRate)

%%%%%% FIXME: the code as written is correct; however the high/low
% nomenclature of variables is very confusing at present.
% made by pshenoy
% FIXME: choice of Rp and Rs is a black art. YUCK. 
% FIXME: so is the choice of low_s, high_s
Rp = 3; Rs = 60; 
delta = 0.001*2/sampRate;
low = band(1); high = band(2);
low_p = band(2)*2/sampRate;
high_p = band(1)*2/sampRate;
if low == 0 %% This is a lowpass filter.
    % Find the order of the filter required .
    low_s = min(1-delta, low_p + 0.1);
    [n_low, wn_low] = buttord(low_p, low_s, Rp, Rs);
    [b a] = butter(n_low, wn_low);
elseif high == sampRate/2  %% This is a highpass filter
    high_s = max(delta, high_p - 0.1);
    [n_high, wn_high] = buttord(high_p, high_s, Rp, Rs);
    [b a] = butter(n_high, wn_high);

else  %% This is a bandpass filter: ignore for now.
    high_s = max(delta, high_p - 0.1);
    low_s = min(1-delta, low_p + 0.1);
    [n_band, wn_band] = buttord([high_p low_p], [high_s low_s], Rp, Rs);
    [b a] = butter(n_band, wn_band);
end

