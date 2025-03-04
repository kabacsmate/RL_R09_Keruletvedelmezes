function sR = rightBreachingPoint(xA, nu, perimeter)
[s_tanR, s_tanL] = tangentPoints(xA,perimeter);
Sd = [s_tanR, s_tanL];

if nu == 1
    sR = s_tanR;
elseif nu == 0
    [sR,~] = closestPointOnPerimeter(xA',perimeter);
else
    fi_R_star = pi - acos(nu);
    if size(perimeter,1) > 1
        % polygon
        for i=1:size(perimeter,1)
            if i == 1
                s = 0;
            else
                s = perimeter(i-1).CumSum;
            end
            if isin(s,Sd,[0,1])
                % breaching point on vertex
                vect = (perimeter(i).StartPoint-xA)/norm(perimeter(i).StartPoint-xA);
                Tp = tangentOfPointOnPerimeter(s,perimeter);
                Tpn = Tp/norm(Tp);
                Tm = tangentOfPointOnPerimeter(s-0.1,perimeter);
                Tmn = Tm/norm(Tm);
                fip = acos(vect*Tpn');
                fim = acos(vect*Tmn');
                if fip < fi_R_star && fi_R_star < fim
                    sR = s;
                    return
                end
            end
        end
    end

    % breaching point is not on vertex
    s = linspaceSd(Sd,floor(arcLen(s_tanR,s_tanL,perimeter)*10));
    minVal = norm(approachAngle(s(1),xA) - fi_R_star);
    sR = s(1);
    for idx = 2:length(s)
        fi = approachAngle(s(idx),xA);
        if norm(fi-fi_R_star) < minVal
            minVal = norm(fi-fi_R_star);
            sR = s(idx);
        end
    end
end

    function fi = approachAngle(s,xA)
        T = tangentOfPointOnPerimeter(s,perimeter);
        Tn = T/norm(T);
        v = (pointOnPerimeter(s,perimeter)-xA)/norm(pointOnPerimeter(s,perimeter)-xA);
        fi = acos(v*Tn');
    end

    function linSd = linspaceSd(Sd, n)
        if Sd(1) < Sd(2)
            linSd = linspace(Sd(1),Sd(2),n);

        elseif Sd(2) == 0
            linSd = linspace(Sd(1),perimeter(end).CumSum,n);
        else
            m = (perimeter(end).CumSum - Sd(1))/(perimeter(end).CumSum - Sd(1) + Sd(2));
            linSd = [linspace(Sd(1),perimeter(end).CumSum,n*m), linspace(0,Sd(2),n*(1-m))];
        end
    end
end