function xy = tangentOfPointOnPerimeter(l,perimeter)
l = rem(l,perimeter(end).CumSum);
if l<0
    l = perimeter(end).CumSum+l;
end
for i=1:size(perimeter,1)
    if l<perimeter(i).CumSum
        if i == 1
            xy = perimeter(i).DerivativeFunction(l);
        else
            xy = perimeter(i).DerivativeFunction(l-perimeter(i-1).CumSum);
        end
        break
    end
end