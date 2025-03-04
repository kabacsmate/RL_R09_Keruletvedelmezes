function defIdxs = defenderSubTeam(sD1,sD2,sD)
defIdxs = [];
for i=1:length(sD)
    if isin(sD(i),[sD1,sD2],[0,0])
        defIdxs(end+1) = i;
    end
end
