function patrollingPath = getPatrollingPath(perimeter,Rorb)
if size(perimeter,1) > 1
     % polygon
     patrollingPath = struct('Length',[],'CumSum',[],'Function',[],'DerivativeFunction',[],'StartPoint',[],'EndPoint',[],'Orientation',[],'Spline',[]);
     for i=1:size(perimeter,1)
         crv = perimeter(i).Spline;
         % Straight piece
         v = crv.coefs(:,1);
         alpha = atan2(v(2),v(1))-pi/2;
         n = [cos(alpha) -sin(alpha);sin(alpha) cos(alpha)]*[1;0];
         crv.coefs(:,2) = crv.coefs(:,2) + Rorb.*n;

         length  = perimeter(i).Length;
         patrollingPath(2*i-1).Length = length;
         patrollingPath(2*i-1).Function = @(l) fnval(crv,l/length*crv.breaks(end))';
         patrollingPath(2*i-1).DerivativeFunction = [];
         patrollingPath(2*i-1).StartPoint = fnval(crv,0)';
         patrollingPath(2*i-1).EndPoint = fnval(crv,crv.breaks(end))';
         patrollingPath(2*i-1).Orientation = perimeter(i).Orientation;
         patrollingPath(2*i-1).Spline = crv;

         % Curve piece
         if i ~= 1
             p1 = patrollingPath(2*i-3).EndPoint;
             p3 = patrollingPath(2*i-1).StartPoint;
             center = perimeter(i-1).EndPoint;
             t1 = wrapTo2Pi(atan2(p1(2)-center(2),p1(1)-center(1)));
             t3 = wrapTo2Pi(atan2(p3(2)-center(2),p3(1)-center(1)));
%              t2 = (t3-t1)/2+t1;

%              p2 = [cos(t2),sin(t2)];
%              points = [p1;p2;p3];
%              crv = cscvn(points');
             length = Rorb*wrapTo2Pi((t3-t1));
             patrollingPath(2*i-2).Length = length;
             patrollingPath(2*i-2).Function = @(l) center + Rorb.*[cos(l./Rorb+t1)',sin(l./Rorb+t1)'];
             patrollingPath(2*i-2).DerivativeFunction = @(l) Rorb.*[-sin(l./Rorb+t1)',cos(l./Rorb+t1)'];
             patrollingPath(2*i-2).StartPoint = p1;
             patrollingPath(2*i-2).EndPoint = p3;
         end
     end
     p1 = patrollingPath(2*size(perimeter,1)-1).EndPoint;
     p3 = patrollingPath(1).StartPoint;
     center = perimeter(end).EndPoint;
     t1 = wrapTo2Pi(atan2(p1(2)-center(2),p1(1)-center(1)));
     t3 = wrapTo2Pi(atan2(p3(2)-center(2),p3(1)-center(1)));

     length = Rorb*wrapTo2Pi((t3-t1));
     patrollingPath(2*size(perimeter,1)).Length = length;
     patrollingPath(2*size(perimeter,1)).Function = @(l) center + Rorb.*[cos(l./Rorb+t1)',sin(l./Rorb+t1)'];
     patrollingPath(2*size(perimeter,1)).DerivativeFunction = @(l) Rorb.*[-sin(l./Rorb+t1)',cos(l./Rorb+t1)'];
     patrollingPath(2*size(perimeter,1)).StartPoint = p1;
     patrollingPath(2*size(perimeter,1)).EndPoint = p3;
     
     patrollingPath = patrollingPath';

     for i=1:size(patrollingPath,1)
        if i == 1
            cumSum = patrollingPath(1).Length;
        else
            cumSum = patrollingPath(i-1).CumSum + patrollingPath(i).Length;
        end
        patrollingPath(i).CumSum = cumSum;
     end
else
    % circle
    patrollingPath = struct('Center',[],'Radius',[],'Length',[],'CumSum',[],'Function',[],'DerivativeFunction',[]);
    r = perimeter.Radius + Rorb;
    O = perimeter.Center;
    patrollingPath.Center = O;
    patrollingPath.Radius = r;
    patrollingPath.Length = 2*r*pi;
    patrollingPath.CumSum = 2*r*pi;
    patrollingPath.Function = @(l) r.*[cos(l./r)',sin(l./r)']+O;
    patrollingPath.DerivativeFunction = @(l) r.*[-sin(l./r)',cos(l./r)'];
end