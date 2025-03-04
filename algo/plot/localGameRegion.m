function [boundary,rho_star] = localGameRegion(defenders, involutes, perimeter)
step = 0.05;
if defenders(1).idx ~= defenders(2).idx
    def1 = defenders(1);
    def2 = defenders(2);
    inv1 = involutes(1);
    inv2 = involutes(2);
    
    [boundary,~] = dR_CA(def1,def2,inv1,inv2);
    rho_star = 0;
%     [boundary2,mid2] = dR_CA(def2,def1,inv2,inv1);
    
%     boundary.x = [boundary1.x,boundary2.x];
%     boundary.y = [boundary1.y,boundary2.y];
    
    % % DEBUG
    % x = []; y = [];
    % for i=0:0.1:2*pi
    %     x = [x,circleFunction.X(i)];
    %     y = [y,circleFunction.Y(i)];
    % end
%     inv1x = []; inv1y = [];
%     for i=0:0.1:1.5*pi
%         inv1x = [inv1x, inv1.X(i,0)];
%         inv1y = [inv1y, inv1.Y(i,0)];
%     end
%     inv2x = []; inv2y = [];
%     for i=0:0.1:1.5*pi
%         inv2x = [inv2x, inv2.X(i,0)];
%         inv2y = [inv2y, inv2.Y(i,0)];
%     end
    % x1 = circleFunction.X(alpha);
    % x2 = circleFunction.X(beta);
    % y1 = circleFunction.Y(alpha);
    % y2 = circleFunction.Y(beta);
    % hold on
    % p1 = plot(x1,y1,'gx');
    % p2 = plot(x2,y2,'mx');
    % p3 = plot(x,y,'r');
    % p4 = plot(inv1x, inv1y, 'g');
    % p5 = plot(inv2x,inv2y, 'm');
    % % DEBUG
    
%     hold on
%     plot(boundary.x,boundary.y,'k')
else
    if size(perimeter,1) > 1
        leftInvolute = involutes.ccw;
        rightInvolute = involutes.cw;
        fx = @(beta,gamma) leftInvolute.X(beta,0) - rightInvolute.X(gamma,0);
        fy = @(beta,gamma) leftInvolute.Y(beta,0) - rightInvolute.Y(gamma,0);
        fxy = @(params) [fx(params(1),params(2));fy(params(1),params(2))];

        options = optimoptions('fsolve','Display','none');
        sol = fsolve(fxy,[3*pi/2 3*pi/2],options);
        
        involuteL.x = []; involuteL.y = [];
        for par = 0:step:sol(1)
            involuteL.x = [involuteL.x,leftInvolute.X(par,0)];
            involuteL.y = [involuteL.y,leftInvolute.Y(par,0)];
        end
        
        involuteR.x = []; involuteR.y = [];
        for par = 0:step:sol(2)
            involuteR.x = [involuteR.x,rightInvolute.X(par,0)];
            involuteR.y = [involuteR.y,rightInvolute.Y(par,0)];
        end
    
        boundary.x = [involuteL.x,flip(involuteR.x)];
        boundary.y = [involuteL.y,flip(involuteR.y)];
        x_star = [leftInvolute.X(sol(1),0),leftInvolute.Y(sol(1),0)];
        l_star = closestPointOnPerimeter(x_star,perimeter);
        rho_star = norm(x_star-pointOnPerimeter(l_star,perimeter));
    else
        leftInvolute = involutes.ccw;
        rightInvolute = involutes.cw;

%         inv1x = []; inv1y = [];
%         for i=0:0.1:perimeter(end).CumSum
%             inv1x = [inv1x, leftInvolute.X(i)];
%             inv1y = [inv1y, leftInvolute.Y(i)];
%         end
%         inv2x = []; inv2y = [];
%         for i=0:0.1:perimeter(end).CumSum
%             inv2x = [inv2x, rightInvolute.X(i)];
%             inv2y = [inv2y, rightInvolute.Y(i)];
%         end
%         figure
%         hold on
%         axis equal
%         plotPerimeter(perimeter)
%         plot(inv1x,inv1y,'r')
%         plot(inv2x,inv2y,'b')

        fx = @(beta,gamma) leftInvolute.X(beta,0) - rightInvolute.X(gamma,0);
        fy = @(beta,gamma) leftInvolute.Y(beta,0) - rightInvolute.Y(gamma,0);
        fxy = @(params) [fx(params(1),params(2));fy(params(1),params(2))];

        options = optimoptions('fsolve','Display','none');
        sol = fsolve(fxy,[perimeter(end).CumSum*2/3, perimeter(end).CumSum*2/3],options);
        
%         p1x = leftInvolute.X(sol(1));
%         p1y = leftInvolute.Y(sol(1));
%         p2x = rightInvolute.X(sol(2));
%         p2y = rightInvolute.Y(sol(2));
%         plot(p1x,p1y,'rx')
%         plot(p2x,p2y,'bx')
        involuteL.x = []; involuteL.y = [];
        for par = 0:step:sol(1)
            involuteL.x = [involuteL.x,leftInvolute.X(par,0)];
            involuteL.y = [involuteL.y,leftInvolute.Y(par,0)];
        end
        
        involuteR.x = []; involuteR.y = [];
        for par = 0:step:sol(2)
            involuteR.x = [involuteR.x,rightInvolute.X(par,0)];
            involuteR.y = [involuteR.y,rightInvolute.Y(par,0)];
        end
    
        boundary.x = [involuteL.x,flip(involuteR.x)];
        boundary.y = [involuteL.y,flip(involuteR.y)];
        
        x_star = [leftInvolute.X(sol(1),0),leftInvolute.Y(sol(1),0)];
        l_star = closestPointOnPerimeter(x_star,perimeter);
        rho_star = norm(x_star-pointOnPerimeter(l_star,perimeter));
    end
end


    function [boundary,middlePoint] = dR_CA(def1, def2, inv1, inv2)
        inv1 = inv1.ccw;
        inv2 = inv2.cw;
        
        [middlePoint,r] = middlePointBetweenTwoDefenders(def1, def2, perimeter);
        
        circleFunction.X = @(alpha) middlePoint(1,1) + cos(alpha) * r;
        circleFunction.Y = @(alpha) middlePoint(1,2) + sin(alpha) * r;
        
        if size(perimeter,1) > 1
            f1x = @(beta,gamma) inv1.X(beta,0) - circleFunction.X(gamma);
            f1y = @(beta,gamma) inv1.Y(beta,0) - circleFunction.Y(gamma);
            f1xy = @(params) [f1x(params(1),params(2));f1y(params(1),params(2))];
            
            f2x = @(beta,gamma) inv2.X(beta,0) - circleFunction.X(gamma);
            f2y = @(beta,gamma) inv2.Y(beta,0) - circleFunction.Y(gamma);
            f2xy = @(params) [f2x(params(1),params(2));f2y(params(1),params(2))];
            
            options = optimoptions('fsolve','Display','none','MaxIterations',800);
            sol1 = myFsolve(f1xy,[0 pi/2],options);
            sol2 = myFsolve(f2xy,[0 -pi/2],options);
            alpha = wrapTo2Pi(sol1(2));
            beta = wrapTo2Pi(sol2(2));

            b1.X = []; b1.Y = []; b2.X = []; b2.Y = []; b3.X = []; b3.Y = [];
            for param = 0:step:sol1(1)
                b1.X = [b1.X, inv1.X(param,0)];
                b1.Y = [b1.Y, inv1.Y(param,0)];
            end
            if param < sol1(1)
                b1.X = [b1.X, inv1.X(sol1(1),0)];
                b1.Y = [b1.Y, inv1.Y(sol1(1),0)];
            end
            for param = alpha:step:(alpha>beta)*2*pi+beta
                b2.X = [b2.X, circleFunction.X(param)];
                b2.Y = [b2.Y, circleFunction.Y(param)];
            end
            if param < (alpha>beta)*2*pi+beta
                b2.X = [b2.X, circleFunction.X((alpha>beta)*2*pi+beta)];
                b2.Y = [b2.Y, circleFunction.Y((alpha>beta)*2*pi+beta)];
            end
            for param = sol2(1):-step:0
                b3.X = [b3.X, inv2.X(param,0)];
                b3.Y = [b3.Y, inv2.Y(param,0)];
            end
            if param > 0
                b3.X = [b3.X, inv2.X(0,0)];
                b3.Y = [b3.Y, inv2.Y(0,0)];
            end
            boundary.x = [b1.X,b2.X,b3.X];
            boundary.y = [b1.Y,b2.Y,b3.Y];

        else
            f1x = @(beta,gamma) inv1.X(beta,0) - circleFunction.X(gamma);
            f1y = @(beta,gamma) inv1.Y(beta,0) - circleFunction.Y(gamma);
            f1xy = @(params) [f1x(params(1),params(2));f1y(params(1),params(2))];
            
            f2x = @(beta,gamma) inv2.X(beta,0) - circleFunction.X(gamma);
            f2y = @(beta,gamma) inv2.Y(beta,0) - circleFunction.Y(gamma);
            f2xy = @(params) [f2x(params(1),params(2));f2y(params(1),params(2))];
            
            options = optimoptions('fsolve','Display','none','MaxIterations',800);
            sol1 = myFsolve(f1xy,[0 pi/2],options);
            sol2 = myFsolve(f2xy,[0 -pi/2],options);
            alpha = wrapTo2Pi(sol1(2));
            beta = wrapTo2Pi(sol2(2));

            b1.X = []; b1.Y = []; b2.X = []; b2.Y = []; b3.X = []; b3.Y = [];
            for param = 0:step:sol1(1)
                b1.X = [b1.X, inv1.X(param,0)];
                b1.Y = [b1.Y, inv1.Y(param,0)];
            end
            if param < sol1(1)
                b1.X = [b1.X, inv1.X(sol1(1),0)];
                b1.Y = [b1.Y, inv1.Y(sol1(1),0)];
            end
            for param = alpha:step:(alpha>beta)*2*pi+beta
                b2.X = [b2.X, circleFunction.X(param)];
                b2.Y = [b2.Y, circleFunction.Y(param)];
            end
            if param < (alpha>beta)*2*pi+beta
                b2.X = [b2.X, circleFunction.X((alpha>beta)*2*pi+beta)];
                b2.Y = [b2.Y, circleFunction.Y((alpha>beta)*2*pi+beta)];
            end
            for param = sol2(1):-step:0
                b3.X = [b3.X, inv2.X(param,0)];
                b3.Y = [b3.Y, inv2.Y(param,0)];
            end
            if param > 0
                b3.X = [b3.X, inv2.X(0,0)];
                b3.Y = [b3.Y, inv2.Y(0,0)];
            end
            boundary.x = [b1.X,b2.X,b3.X];
            boundary.y = [b1.Y,b2.Y,b3.Y];
        end

        % % DEBUG
%         x = []; y = [];
%         for i=0:0.1:2*pi
%             x = [x,circleFunction.X(i)];
%             y = [y,circleFunction.Y(i)];
%         end
%         inv1x = []; inv1y = [];
%         for i=0:0.1:1.5*pi
%             inv1x = [inv1x, inv1.X(i,0)];
%             inv1y = [inv1y, inv1.Y(i,0)];
%         end
%         inv2x = []; inv2y = [];
%         for i=0:0.1:1.5*pi
%             inv2x = [inv2x, inv2.X(i,0)];
%             inv2y = [inv2y, inv2.Y(i,0)];
%         end
% %         x1 = circleFunction.X(alpha);
% %         x2 = circleFunction.X(beta);
% %         y1 = circleFunction.Y(alpha);
% %         y2 = circleFunction.Y(beta);
%         hold on
% %         p1 = plot(x1,y1,'gx');
% %         p2 = plot(x2,y2,'mx');
%         hold on
%         p3 = plot(x,y,'m');
%         p4 = plot(inv1x, inv1y, 'g');
%         p5 = plot(inv2x,inv2y, 'm');
        % % DEBUG

       
    end
    function sol = myFsolve(fun,x0,options)
        [sol,~,exitflag] = fsolve(fun,x0,options);
        if exitflag <= 0
            x0(1) = x0(1) + 0.1;
            x0(2) = x0(2) + pi/4;
            sol = myFsolve(fun,x0,options);
        elseif sol(1) < 0
            x0(1) = x0(1) + pi/4;
            sol = myFsolve(fun,x0,options);
        end
    end


end



