function good_chs = remove_bad_channels(signal, sampling_rate,para)
% lower para to impose more restriction
% gets the 50 Hz noise power using an IIR peak filter
num_chs = size(signal, 2);
[b,a] = iirpeak(50/(sampling_rate/2), 0.001);
noise_level = mean(sqrt(filter(b,a, signal).^2),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\
clf;
stem(noise_level);
hold on;
plot([0,length(noise_level)],[median(noise_level) + para*mad(noise_level, 1),median(noise_level) + para*mad(noise_level, 1)],'--');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the good channels are defined as those which power in the 60 Hz noise is
% not significantly different from the median 60 Hz noise across all ECoG
% channels. We arbitrarily define significance as the median of the 
% noise across channels + 10 times its median absolute deviation: 

good_chs = [];
for idx = 1:num_chs
    if noise_level(idx) < median(noise_level) + para*mad(noise_level, 1)
        good_chs = [good_chs idx]; %#ok<AGROW>
    end
end

end