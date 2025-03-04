function uA = intruderNaiveStrategy(~,intruders, nu, perimeter)

uA = zeros(size(intruders,1),2);
for i=1:size(intruders,1)
    param = closestPointOnPerimeter(intruders(i).Position,perimeter);
    p = pointOnPerimeter(param,perimeter);
    uA(i,:) = nu * (p-intruders(i).Position)/norm(p-intruders(i).Position);
end

