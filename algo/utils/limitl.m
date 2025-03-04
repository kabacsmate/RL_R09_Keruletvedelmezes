function l = limitl(l,perimeter)
    l = rem(l,perimeter(end).CumSum);
    if l<0
        l = perimeter(end).CumSum+l;
    end
end