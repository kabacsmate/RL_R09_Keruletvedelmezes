function wD = defenderTeamStrategy_MM(defenders,intruders,nu, perimeter)
if isempty(defenders)
    wD = [];
    return
end
B = false(size(defenders,1),size(intruders,1));
for d=1:size(defenders,1)
    for i=1:size(intruders,1)
        sD = defenders(d).l;
        xA = intruders(i).Position;
        B(d,i) = isInRD(sD, xA, nu, perimeter);
    end
end
assignment = maxBPM(B');
assignment = supplementary_assignment(defenders,intruders,assignment,nu,perimeter);
wD = zeros(size(defenders,1),1);
for d=1:length(assignment)
    i = assignment(d);
    if i ~= 0
        wD(d) = defenderControl1v1(defenders(d).l, intruders(i).Position, nu, perimeter);
    end
end
