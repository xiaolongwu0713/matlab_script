function [areavert,vertNo] = areavert(area)
%[areavert,vertNo] = areavert(area)
%area: cell array
%areavert: 2 x 1 cell array, inside a area x 1 cell array, inside vert x 1
%vector==vertex index
%vertNo:2 x 1 vector, the number of vertices in each hemisphere
%given area, output the vertices index belonging to the area
persistent M
if isempty(M)
    load(fullfile(env.get('stdbrain'),'Cortex_Center_aparc'),'M');
end
for j=1:2
    allarea = M(j).struct_names;
    [C,ia,ic] = unique(M(j).Cortex_Color(:,2:4),'rows');%C = A(ia),A = C(ic)
    [Lia,Locb] = ismember(area,allarea);
    assert(all(Lia),'the input area name is illegal, check spell!');
    areaCenterIdx = M(j).table(Locb,5);%area x 1
    areavert{j} = arrayfun(@(i) find(abs(M(j).BV-areaCenterIdx(i))<1e-3),1:length(area),...
        'un',0);
%     areaCenterColor = arrayfun(@(i) M(j).Cortex_Color((M(j).Cortex_Color(:,1)-...
%         areaCenterIdx(i))<1e-6,2:4),1:length(areaCenterIdx),'un',0);
%     areaCenterColor = cat(1,areaCenterColor{:});%area x 3
%     [colortmp,iaa,icc] = intersect(areaCenterColor,C,'stable','rows');%C(icc) = areaCenterColor
%     areavert{j} = arrayfun(@(i) M(j).Cortex_Color((ic==icc(i)),1),1:length(area),'un',0);
    vertNo(j) = size(M(j).vert,1);
end
areavert{1} = cellfun(@(x) x+vertNo(2),areavert{1},'un',0);
areavert = arrayfun(@(i) [areavert{1}{i};areavert{2}{i}],1:length(area),'un',0);
end

