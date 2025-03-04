function res = isInRpair(sD1, sD2, xA, nu, perimeter)
% call only to defenders that cannot separately capture xA
sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);
isInD1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
if isInD1D2
    sDi = sD1;
    sDj = sD2;
else
    sDi = sD2;
    sDj = sD1;
end
smid = middlePointOnPerimeter(sDi, sDj, perimeter);
Jmid = arcLen(sDi,smid,perimeter) - norm(pointOnPerimeter(smid,perimeter) - xA) / nu;
if Jmid < 0
    res = true;
else
    res = false;
end