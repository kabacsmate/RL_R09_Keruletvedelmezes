function res = isInRC(sD1, sD2, xA, nu, perimeter)
isInD1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
if ~isInD1D2
    res = false;
    return
end

sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);
smid = middlePointOnPerimeter(sD1, sD2, perimeter);

if isin(sL,[sD1,smid],[1,0])
    J = arcLen(sD1,sL,perimeter) - norm(pointOnPerimeter(sL,perimeter) - xA) / nu;
elseif isin(sR,[smid,sD2],[0,1])
    J = arcLen(sR,sD2,perimeter) - norm(xA - pointOnPerimeter(sR,perimeter)) / nu;
else
    J = arcLen(sD1,smid,perimeter) - norm(pointOnPerimeter(smid,perimeter) - xA) / nu;
end
if J > 0
    res = true;
    return
else
    res = false;
    return
end
end