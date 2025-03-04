function uA = intruderControl1v1(sD, xA, nu, perimeter)
% INPUT
% sD: A védett terület határát leíró függvény paraméter, mely az adott védő
% pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% uA: A támadó beavatkozó jele, mely egy sebességvektor.

sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);

[gamma_sL,~] = pointOnPerimeter(sL,perimeter);
[gamma_sR,~] = pointOnPerimeter(sR,perimeter);

if (true == determineRegion1v1(sD, xA, nu, perimeter))
    uA = nu * (gamma_sL-xA)/norm(gamma_sL-xA);
else
    uA = nu*(gamma_sR-xA)/norm(gamma_sR-xA);
end

