function [param, dist] = closestPointOnPerimeter(point,perimeter)
if isfield(perimeter,'Spline')
    point = point';
    dist = Inf;
    % Iterate perimeter sections
    for i = 1:size(perimeter,1)
        crv = perimeter(i).Spline;
        crvlength = perimeter(i).Length;
    
        crv.coefs(abs(crv.coefs) < 1e-10) = 0;
        crv.order = size(crv.coefs,2);
        Dcrv = fnder(crv);
        
        % Iterate section pieces
        for j=1:crv.pieces
            coefs = crv.coefs(2*j-1:2*j,:);
            Dcoefs = Dcrv.coefs(2*j-1:2*j,:);
        
            coefsNeg = -coefs;
            coefsSub = coefsNeg;
            coefsSub(:,end) = coefsNeg(:,end) + point;
        
            pp = sum_poly(conv(coefsSub(1,:),Dcoefs(1,:)),conv(coefsSub(2,:),Dcoefs(2,:)));
            root = real(roots(pp));
            root(root < 0) = 0;
            root(crv.breaks(j+1)-crv.breaks(j) < root) = crv.breaks(j+1)-crv.breaks(j);
            root = unique(root);
            for k=1:length(root)
                x = polyval(coefs(1,:),root(k));
                y = polyval(coefs(2,:),root(k));
                if norm(point-[x;y]) < dist
                    dist = norm(point-[x;y]);
                    if i == 1
                        param = (root(k) + crv.breaks(j))/crv.breaks(end)*crvlength;
                    else
                        param = (root(k) + crv.breaks(j))/crv.breaks(end)*crvlength + perimeter(i-1).CumSum;
                    end
                end
            end
        end
    end
else
    % Circle
    v = (point - perimeter.Center);
    alpha = wrapTo2Pi(atan2(v(2),v(1)));
    param = perimeter.Radius * alpha;
    dist = norm(v)-perimeter.Radius;
end
end
