function xy = derivativeOfPointOnPerimeter(l,perimeter)
l = rem(l,perimeter(end).CumSum);
l(l<0) = l(l<0) + perimeter(end).CumSum;
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