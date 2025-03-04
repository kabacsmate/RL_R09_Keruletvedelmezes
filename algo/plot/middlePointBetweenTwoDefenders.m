function [middlePoint,r] = middlePointBetweenTwoDefenders(def1, def2, perimeter)
if def1.l < def2.l
    r = (def2.l - def1.l)/2;
else
    r = (def2.l - def1.l + perimeter(end).CumSum)/2;
end
[middlePoint,~] = pointOnPerimeter(r + def1.l,perimeter);