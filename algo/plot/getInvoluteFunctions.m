function involutes = getInvoluteFunctions(defenderParam, perimeter)
if size(perimeter,1) > 1
    % polygon

    % Calculate some initial parameters
    [~, section] = pointOnPerimeter(defenderParam,perimeter);
    alphaOffset = perimeter(section).Orientation;
    
    [leftInvolute, rightInvolute] = generateInvolutesForPolygon(perimeter,defenderParam,section, alphaOffset);
    involutes.ccw = leftInvolute;
    involutes.cw = rightInvolute;
else
    l0 = defenderParam;
    f =  @perimeter.Function;
    df = @perimeter.DerivativeFunction;
    ndf = @(l) norm(df(l));
    % l increases from l0 to l0+perimeter.length
    invccw = @(l,a) f(limitl(l0+l,perimeter))-df(limitl(l0+l,perimeter))./ndf(limitl(l0+l,perimeter))*(l+a);
    % l increases from l0 to l0+perimeter.length
    invcw = @(l,a) f(limitl(l0-l,perimeter))+df(limitl(l0-l,perimeter))./ndf(limitl(l0-l,perimeter))*(l+a);
    involutes.ccw.X = @(l,a) table(invccw(l,a)).Var1(1);
    involutes.ccw.Y = @(l,a) table(invccw(l,a)).Var1(2);
    involutes.cw.X = @(l,a) table(invcw(l,a)).Var1(1);
    involutes.cw.Y = @(l,a) table(invcw(l,a)).Var1(2);
end
