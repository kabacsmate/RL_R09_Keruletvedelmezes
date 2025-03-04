function [res,J] = isInRD(sD, xA, nu, perimeter)
% INPUT
% sD: A védett terület határát leíró függvény paraméter, mely az adott védő
% pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% res: Igaz, ha a támadót a védekező garantáltan képes önállóan elfogni és
% hamis, ha nem.
% J: A támadó és védő 1-1 elleni játéka esetén az optimális stratégiák
% melletti játék értéke (mérési útmutató (2.7) összefüggés).

sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);

is_in_Left = determineRegion1v1(sD, xA, nu, perimeter);

s_DL = arcLen(sD, sL, perimeter);
[gamma_sL,~] = pointOnPerimeter(sL,perimeter);
s_RD = arcLen(sR, sD, perimeter);
[gamma_sR,~] = pointOnPerimeter(sR,perimeter);

JL_star = s_DL - (norm(gamma_sL - xA))/(nu);
JR_star = s_RD - (norm(xA - gamma_sR))/(nu);

if is_in_Left
    J = JL_star;
else
    J = JR_star;
end

if 0 < J
    res = true;
else
    res = false;
end


