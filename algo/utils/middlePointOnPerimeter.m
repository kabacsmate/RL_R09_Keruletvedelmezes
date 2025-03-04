function smid = middlePointOnPerimeter(s1, s2, perimeter)
if s1 < s2
    smid = (s2 - s1)/2 + s1;
else
    smid = (s2 - s1 + perimeter(end).CumSum)/2 + s1;
end

smid = rem(smid,perimeter(end).CumSum);
smid(smid<0) = smid(smid<0) + perimeter(end).CumSum;