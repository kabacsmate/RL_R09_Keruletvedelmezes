function rho_star = calculateRhoStar(defenders,perimeter)
rho_star = 0;
for d=1:size(defenders,1)
    involutes = getInvoluteFunctions(defenders(d).l, perimeter);
    [~,rho] = localGameRegion([defenders(d),defenders(d)],[involutes,involutes],perimeter);
    if rho_star < rho
        rho_star = rho;
    end
end