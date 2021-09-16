function [bin_power, bin_centers]=phase_power(power,phase,num_bins)
% function [bin_power]=phase_powr(data,num_bins)
% this function calculates the mean power in "num_bins" evenly spaced bins
% note that it explicitly normalizes for uneven density
% need to modify to return a reshuffling statistic

bin_edges=[-pi:(2*pi/(num_bins)):(pi)];
bin_centers=bin_edges(1:(num_bins))+pi/num_bins;
bin_power=zeros(1,num_bins);


for k=1:num_bins
    t_ind=find(and(phase<bin_edges(k+1),phase>=bin_edges(k)));
    bin_power(k)=mean(power(t_ind));
end

%