function xB = greedyBreachingPoint(sD,xA,nu,perimeter)
sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);

[~,idx] = sort(sD);
sD = sD(idx);
[lA, ~] = closestPointOnPerimeter(xA,perimeter);
if lA <= sD(1) || sD(end) <= lA
    sDL = sD(end);
    sDR = sD(1);
else
    idx = find(sD < lA);
    sDL = sD(idx(end));
    sDR = sD(idx(end)+1);
end
sB = middlePointOnPerimeter(sDL,sDR, perimeter);
if ~isin(sB,[sR,sL],[1,1])
    if arcLen(sL,sB,perimeter) < arcLen(sB,sR,perimeter)
        sB = sL;
    else
        sB = sR;
    end
end
xB = pointOnPerimeter(sB,perimeter);
        