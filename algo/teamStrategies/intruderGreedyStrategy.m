function uA = intruderGreedyStrategy(defenders,intruders,nu,perimeter)
if isempty(defenders)
    uA = intruderNaiveStrategy(defenders,intruders,nu,perimeter);
    return
end

uA = zeros(size(intruders,1),2);
sD = zeros(size(defenders,1),1);
for d=1:size(defenders,1)
    sD(d) = defenders(d).l;
end

if size(defenders,1) == 1
    for i=1:size(intruders,1)
        xA = intruders(i).Position;
        uA(i,:) = intruderControl1v1(sD(1),xA,nu,perimeter);
    end
    return
elseif size(defenders,1) == 2
    for i=1:size(intruders,1)
        xA = intruders(i).Position;
        uA(i,:) = intruderControl2v1(sD(1),sD(2),xA,nu,perimeter);
    end
    return
else
    for i=1:size(intruders,1)
    xA = intruders(i).Position;
    xB = greedyBreachingPoint(sD,xA,nu,perimeter);
    uA(i,:) = nu * (xB-xA)/norm(xB-xA);
    end
    return
end


