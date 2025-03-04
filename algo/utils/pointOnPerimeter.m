function [xy,section] = pointOnPerimeter(l,perimeter)
xy = zeros(length(l),2);
section = zeros(length(l),1);
l = rem(l,perimeter(end).CumSum);
l(l<0) = l(l<0) + perimeter(end).CumSum;

for i=1:size(perimeter,1)
    if i == 1
        idx = l<=perimeter(i).CumSum;
    else
         idx = l<=perimeter(i).CumSum & perimeter(i-1).CumSum<l;
    end
    if any(idx)
        if i == 1
            xy(idx,:) = perimeter(i).Function(l(idx));
        else
            xy(idx,:) = perimeter(i).Function(l(idx)-perimeter(i-1).CumSum);
        end
        section(idx) = i;
%         break
    end
end