function len = arcLen(sA, sB, perimeter)
if sA <= sB
    len = sB - sA;
else
    len = perimeter(end).CumSum - sA + sB;
end