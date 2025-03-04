function uA = intruderLGRStrategy(defenders,intruders,nu,perimeter)
if isempty(defenders)
    uA = intruderNaiveStrategy(defenders,intruders,nu,perimeter);
    return
end
uA = zeros(size(intruders,1),2);

defSize = size(defenders,1);
sD = zeros(defSize,1);
for i=1:defSize
    sD(i) = defenders(i).l;
end

defendersToPair = 1:defSize;

if length(defendersToPair) > 1
    defenderPairs = nchoosek(defendersToPair,2);
    defenderPairs = [defenderPairs;flip(defenderPairs,2)];
else
    defenderPairs = [];
end
defenderPairs = [defenderPairs;[defendersToPair',defendersToPair']];

q = zeros(size(defenderPairs,1),1);
N = false(size(defenderPairs,1));
SA = cell(size(defenderPairs,1),1);
SD = cell(size(defenderPairs,1),1);

for i=1:size(defenderPairs,1)
    sD1 = sD(defenderPairs(i,1));
    sD2 = sD(defenderPairs(i,2));
    nA = 0;
    for j=1:size(intruders,1)
        xA = intruders(j).Position;
        if sD1 ~= sD2
            if isInRC(sD1, sD2, xA, nu, perimeter)
                nA = nA + 1;
                SA{i}(end+1) = j;
            end
        else
            if ~isInRD(sD1,xA,nu,perimeter)
                nA = nA + 1;
                SA{i}(end+1) = j;
            end
        end
    end
    SD{i} = defenderSubTeam(sD1,sD2,sD);
    nD = length(SD{i});
    q(i) = nA - nD;

    for j=1:size(defenderPairs,1)
        sD3 = sD(defenderPairs(j,1));
        sD4 = sD(defenderPairs(j,2));
        N(i,j) = isin(sD3,[sD1,sD2],[0,0]) | isin(sD4,[sD1,sD2],[0,0]);
    end
end
N = N|N';
M = logical(BK_MaxIS(N));
[~,idx] = max(M'*q);
resultingLGRs = find(M(:,idx));

assignedIntruders = [];
for i=1:length(resultingLGRs)
    idxD1 = defenderPairs(resultingLGRs(i),1);
    idxD2 = defenderPairs(resultingLGRs(i),2);
    sD1 = sD(idxD1);
    sD2 = sD(idxD2);
    for j=1:length(resultingLGRs)
        for k=1:length(SA{resultingLGRs(j)})
            idxA = SA{resultingLGRs(j)}(k);
            xA = intruders(idxA).Position;
            if idxD1 ~= idxD2
                uA(idxA,:) = intruderControl2v1(sD1,sD2,xA,nu,perimeter);
            else
                sB = middlePointOnPerimeter(sD1,sD1,perimeter);
                sL = leftBreachingPoint(xA, nu, perimeter);
                sR = rightBreachingPoint(xA, nu, perimeter);
                if ~isin(sB,[sR,sL],[1,1])
                    if arcLen(sL,sB,perimeter) < arcLen(sB,sR,perimeter)
                        sB = sL;
                    else
                        sB = sR;
                    end
                end
                xB = pointOnPerimeter(sB,perimeter);
                uA(idxA,:) = nu*(xB-xA)/norm(xB-xA);
            end
        assignedIntruders(end+1) = idxA;
        end
    end
end

unassignedIntruders = 1:size(intruders,1);
unassignedIntruders = unassignedIntruders(~ismember(unassignedIntruders,assignedIntruders));

uAgr = intruderGreedyStrategy(defenders,intruders(unassignedIntruders),nu,perimeter);

uA(unassignedIntruders,:) = uAgr;
