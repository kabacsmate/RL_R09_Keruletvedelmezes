function [tanR,tanL] = tangentPointPoly(point, perimeter)
n = size(perimeter,1);
V = zeros(n+1,2);
for i=1:n
    V(i,:) = perimeter(i).StartPoint;
end
V(n+1,:) = perimeter(1).StartPoint;

tanL = 1;
tanR = 1;
eprev = isLeft(V(1,:),V(2,:),point);
for i=2:n
    enext = isLeft(V(i,:),V(i+1,:),point);
    if eprev <= 0 && enext > 0
        tanL = i;
    elseif eprev > 0 && enext <= 0
        tanR = i;
    end
    eprev = enext;
end


%      Return: >0 for point left of the line through V1 and V2
%              =0 for point on the line
%              <0 for point right of the line
    function res = isLeft(V1,V2,point)
        res = (V2(1)-V1(1)) * (point(2)-V1(2)) - (point(1)-V1(1)) * (V2(2)-V1(2));
    end
end