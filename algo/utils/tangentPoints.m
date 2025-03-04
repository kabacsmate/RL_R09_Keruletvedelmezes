function [s_tanR,s_tanL] = tangentPoints(xA,perimeter)


if size(perimeter,1) > 1
    % polygon
    [tanR,tanL] = tangentPointPoly(xA, perimeter);
    if tanR == 1
        s_tanR = 0;
    else
        s_tanR = perimeter(tanR-1).CumSum;
    end
    if tanL == 1
        s_tanL = 0;
    else
        s_tanL = perimeter(tanL-1).CumSum;
    end

else
     if isfield(perimeter,'Spline')
         crv = perimeter.Spline;
         Dcrv = fnder(crv);
         for i=1:crv.pieces
             poly = crv.coefs(2*i-1:2*i,:);
             Dpoly = Dcrv.coefs(2*i-1:2*i,:);
             dx = [0,0,0,xA(1,1)] - poly(1,:);
             dy = [0,0,0,xA(1,2)] - poly(2,:);
             left = conv(dy,Dpoly(1,:));
             right = conv(Dpoly(2,:),dx);
             root = roots(left-right);
             root = root(root == real(root));
             root = root(0 < root & root < (crv.breaks(i+1)-crv.breaks(i)));
             if ~isempty(root)
                 for r = 1:length(root)
                     d = [polyval(Dpoly(1,:),root(r)),polyval(Dpoly(2,:),root(r))];
                     d = d/norm(d);
                     p = [polyval(poly(1,:),root(r)),polyval(poly(2,:),root(r))];
                     v = (xA-p)/norm(xA-p);
                     if norm(d - v) < 1e-5
                         s_tanR = (root(r) + crv.breaks(i))/crv.breaks(end)*perimeter.Length;
                     elseif norm(d + v) < 1e-5
                         s_tanL = (root(r) + crv.breaks(i))/crv.breaks(end)*perimeter.Length;
                     end
                 end
             end
         end
         
         % convex spline
%          options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','none');
%          funR = @(s) perimeter.DerivativeFunction(s)/norm(perimeter.DerivativeFunction(s))... 
%          - (xA - perimeter.Function(s))/norm(xA - perimeter.Function(s));
%          funL = @(s) perimeter.DerivativeFunction(s)/norm(perimeter.DerivativeFunction(s))... 
%          + (xA - perimeter.Function(s))/norm(xA - perimeter.Function(s));
%          s0 = closestPointOnPerimeter(xA,perimeter);
%          uLim = perimeter(end).CumSum;
%          s_tanR = myFsolve(funR,s0,uLim,options);
%          s_tanL = myFsolve(funL,s0,uLim,options);      
% 
%          if any([s_tanR,s_tanL] < 0) || any(perimeter(end).CumSum < [s_tanR,s_tanL])
%              errordlg("Could not find tangent point.", "Error")   
%          end
     else
         % circle
         O = perimeter.Center;
         r = perimeter.Radius;
         d0 = norm(xA-O);
         xtanL = r^2/d0^2*(xA-O) + r/d0^2*sqrt(d0^2-r^2) * [-(xA(2)-O(2)),xA(1)-O(1)];
         xtanR = r^2/d0^2*(xA-O) - r/d0^2*sqrt(d0^2-r^2) * [-(xA(2)-O(2)),xA(1)-O(1)];

         fiL = wrapTo2Pi(atan2(xtanL(2),xtanL(1)));
         fiR = wrapTo2Pi(atan2(xtanR(2),xtanR(1)));

         s_tanL = r*fiL;
         s_tanR = r*fiR;
     end
    
end