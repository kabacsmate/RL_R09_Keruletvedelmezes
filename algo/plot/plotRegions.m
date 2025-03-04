function plotRegions(defenders,intruders,nu,defenderAlgo,perimeter,patrolPath, patrols)
if isempty(defenders)
    return
end
if ~isempty(findobj('type','figure','Name','Regions'))
    clf(findobj('type','figure','Name','Regions'))
    fig = gcf;
    ax = gca;
else
    fig = figure('Name','Regions','NumberTitle','off','Position',[910,100,550,550]);
    ax = gca;
end
figure(fig)
axis equal
hold on

minX = zeros(size(defenders,1),1);
maxX = zeros(size(defenders,1),1);
minY = zeros(size(defenders,1),1);
maxY = zeros(size(defenders,1),1);
C = colororder(fig);
for d=1:size(defenders,1)
    involutes = getInvoluteFunctions(defenders(d).l, perimeter);
    boundary = localGameRegion([defenders(d),defenders(d)],[involutes,involutes],perimeter);

    minX(d) = min(boundary.x)-1;
    maxX(d) = max(boundary.x)+1;
    minY(d) = min(boundary.y)-1;
    maxY(d) = max(boundary.y)+1;

    fill([boundary.x],[boundary.y],C(d,:),'EdgeColor',C(d,:),'FaceAlpha',0.1)
end
if defenderAlgo == 1 && size(defenders,1) > 1
    defSize = size(defenders,1);
    pairSize = nchoosek(defSize,2)*2;
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
        wD = zeros(size(defenders,1),1);
        return
    end
    graphEdges(:,1) = num2cell(row);
    graphEdges(:,2) = arrayfun(@decomposeToDefenders,col,'UniformOutput',false);
    
    D = false(size(graphEdges,1));
    for i=1:size(row,1)
        for j=i+1:size(row,1)
            D(i,j) = graphEdges{i,1}==graphEdges{j,1} || any(intersect(graphEdges{i,2},graphEdges{j,2}));
        end
    end
    D = triu(D,1) + tril(D');
    M = logical(BK_MaxIS(D));
    [~,c] = max(sum(M,1));
    vertices = M(:,c);
    finalPairs = graphEdges(vertices,:);

    for p=1:size(finalPairs,1)
        if size(finalPairs{p,2},2) == 2
            defenderPair = finalPairs{p,2};
            intruder = finalPairs{p,1};
            d1 = defenderPair(1);
            d2 = defenderPair(2);
            sD1 = defenders(d1).l;
            sD2 = defenders(d2).l;
            xA = intruders(intruder).Position;
            isInD1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
            if ~isInD1D2
                tmp = d1;
                d1 = d2;
                d2 = tmp;
            end
            inv1 = getInvoluteFunctions(defenders(d1).l, perimeter);
            inv2 = getInvoluteFunctions(defenders(d2).l, perimeter);
            boundary = localGameRegion([defenders(d1),defenders(d2)],[inv1,inv2],perimeter);
            plot(boundary.x,boundary.y,'k')
        end
    end
end
minX = min(minX);
maxX = max(maxX);
minY = min(minY);
maxY = max(maxY);

plotPerimeter(perimeter,'g')
if size(perimeter,1) > 1
    % polygon
    xVertex = []; yVertex= [];
    for i=1:size(perimeter,1)
        xy = perimeter(i).StartPoint;
        xVertex = [xVertex,xy(1)];
        yVertex = [yVertex,xy(2)];
    end
else
    s = linspace(0,perimeter(end).CumSum,floor(10*perimeter(end).CumSum));
    xy = pointOnPerimeter(s,perimeter);
    xVertex = xy(:,1);
    yVertex = xy(:,2);
end
fill(xVertex,yVertex,'white','EdgeColor','none')

if ~isempty(patrolPath)
    for i=1:size(patrolPath,1)
        segment = patrolPath(i);
        l = [0:0.1:segment.Length,segment.Length];
        xy = segment.Function(l);
        p = plot(xy(:,1),xy(:,2),'g');
    end
end
for i=1:size(intruders,1)
    idx = intruders(i).idx;
    pos = intruders(i).Position;
    scatter(pos(1),pos(2), 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', 'Marker','square');
    text(pos(1)+0.5,pos(2)+0.5,string(idx))
end
for i=1:size(defenders,1)
    idx = defenders(i).idx;
    pos = defenders(i).Position;
    scatter(pos(1),pos(2),'filled','MarkerEdgeColor','blue','MarkerFaceColor','blue')
    text(pos(1)+0.2,pos(2)+0.5,string(idx))
end
for i=1:length(patrols)
    pos = patrols(i).Position;
    scatter(pos(1), pos(2), 'filled', 'go');
    r = patrols(i).DetectionRadius;
    d = r*2;
    px = patrols(i).Position(1)-r;
    py = patrols(i).Position(2)-r;
    rectangle('Position',[px,py,d,d],'Curvature',[1,1],'LineStyle',':','EdgeColor', 'green');
end
hold off
% xlim(ax,[minX,maxX])
% ylim(ax,[minY,maxY])
% axis([-3,18,-1,20])
axis([-0.5,20.5,-0.5,20.5])
set(ax,'Position',tightPosition(ax,IncludeLabels=true))
title(ax,'Winning regions');
xlabel(ax,'X');
ylabel(ax,'Y');

    function defenders = decomposeToDefenders(value)
                if value > defSize
                    defenders = defenderPairs(value-defSize,:);
                else
                    defenders = value;
                end
    end
end