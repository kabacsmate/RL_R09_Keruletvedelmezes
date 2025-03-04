function plotPerimeter(perimeter,color)
if isfield(perimeter,'Spline')
    for i=1:size(perimeter,1)
        fnplt(perimeter(i).Spline,'Color',color)
    end
else
    r = perimeter.Radius;
    d = r*2;
    px = perimeter.Center(1)-r;
    py = perimeter.Center(2)-r;
    rectangle('Position',[px py d d],'Curvature',[1,1],'EdgeColor',color);
end