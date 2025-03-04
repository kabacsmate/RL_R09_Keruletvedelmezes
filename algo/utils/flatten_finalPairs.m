function assignment = flatten_finalPairs(finalPairs,defenders)
defSize = length(defenders);
assignment = zeros(1,defSize);

for p=1:size(finalPairs,1)
    if size(finalPairs{p,2},2) == 1
        i = finalPairs{p,1};
        d = finalPairs{p,2};
        assignment(d) = i;
    else
        i = finalPairs{p,1};
        defenderPair = finalPairs{p,2};
        d1 = defenderPair(1);
        d2 = defenderPair(2);
        assignment(d1) = i;
        assignment(d2) = i;
    end
end
