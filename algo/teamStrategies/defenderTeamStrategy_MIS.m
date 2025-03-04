function wD = defenderTeamStrategy_MIS(defenders,intruders,nu,perimeter)
if isempty(defenders)
    wD = [];
    return
end
defSize = size(defenders,1);
wD = zeros(defSize,1);

if defSize > 1
    pairSize = nchoosek(defSize,2)*2;
else
    pairSize = 0;
end
B = false(size(intruders,1),defSize+pairSize);
for d=1:size(defenders,1)
    for i=1:size(intruders,1)
        sD = defenders(d).l;
        xA = intruders(i).Position;
        B(i,d) = isInRD(sD, xA, nu, perimeter);
    end
end
defendersToPair = 1:defSize;
if length(defendersToPair) > 1
    defenderPairs = nchoosek(defendersToPair,2);
    defenderPairs = [defenderPairs;flip(defenderPairs,2)];
    for i=1:size(defenderPairs,1)
        def1 = defenderPairs(i,1);
        def2 = defenderPairs(i,2);
        sD1 = defenders(def1).l;
        sD2 = defenders(def2).l;
        uncapturebleSeparately = ~B(1:size(intruders,1),def1) & ~B(1:size(intruders,1),def2);
        if any(uncapturebleSeparately)
            uncapturableIntrIdx = find(uncapturebleSeparately);
            for j=1:length(uncapturableIntrIdx)
                xA = intruders(uncapturableIntrIdx(j)).Position;
                isInD1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
                if isInD1D2
                    inRC = isInRC(sD1,sD2,xA,nu,perimeter);
                    B(uncapturableIntrIdx(j),defSize+i) = ~inRC;
                end
            end
        end
    end
end
[row,col] = find(B);
if isempty(row)
    assignment = zeros(1,size(defenders,1));
    finalPairs = {};
else
    graphEdges(:,1) = num2cell(row);
    graphEdges(:,2) = arrayfun(@decomposeToDefenders,col,'UniformOutput',false);
    
    D = false(size(graphEdges,1));
    for i=1:length(row)
        for j=i+1:length(row)
            D(i,j) = graphEdges{i,1}==graphEdges{j,1} || any(intersect(graphEdges{i,2},graphEdges{j,2}));
        end
    end
    D = triu(D,1) + tril(D');
    M = logical(BK_MaxIS(D));
    [~,c] = max(sum(M,1));
    vertices = M(:,c);
    finalPairs = graphEdges(vertices,:);
    
    assignment = flatten_finalPairs(finalPairs,defenders);
end

[~,newAssignment] = supplementary_assignment(defenders,intruders,assignment,nu,perimeter);
for n=1:size(newAssignment,1)
    p = size(finalPairs,1)+1;
    finalPairs{p,1} = newAssignment(n,1);
    finalPairs{p,2} = newAssignment(n,2);
end

for p=1:size(finalPairs,1)
    if size(finalPairs{p,2},2) == 1
        intruderIdx = finalPairs{p,1};
        defenderIdx = finalPairs{p,2};
        sD = defenders(defenderIdx).l;
        xA = intruders(intruderIdx).Position;
        wD(defenderIdx) = defenderControl1v1(sD, xA, nu, perimeter);
    else
        intruderIdx = finalPairs{p,1};
        defenderPair = finalPairs{p,2};
        defenderIdx1 = defenderPair(1);
        defenderIdx2 = defenderPair(2);
        sD1 = defenders(defenderIdx1).l;
        sD2 = defenders(defenderIdx2).l;
        xA = intruders(intruderIdx).Position;
        [wD1,wD2] = defenderControl2v1(sD1,sD2,xA,nu,perimeter);
        wD(defenderIdx1) = wD1;
        wD(defenderIdx2) = wD2;
    end
end

    function defenders = decomposeToDefenders(value)
            if value > defSize
                defenders = defenderPairs(value-defSize,:);
            else
                defenders = value;
            end
    end
end