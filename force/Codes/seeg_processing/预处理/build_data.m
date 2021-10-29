function [power_of_gamma]=build_data(power_of_broadband_gamma,triggerseeg)
for i=1:40
    for j=1:110
        power_of_gamma(:,j,i)=power_of_broadband_gamma(triggerseeg(i):(triggerseeg(i)+30000-1),j);
    end
end
end