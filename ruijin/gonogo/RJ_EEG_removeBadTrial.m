function res = RJ_EEG_removeBadTrial(tri_power)

res = [];
triAllMean = mean(tri_power,'all');
triSingleMean = mean(tri_power, 2);
for i = 1:length(triSingleMean)
    if triSingleMean(i,1) > 1.5 * triAllMean
        res = [res, i];
    end
end

