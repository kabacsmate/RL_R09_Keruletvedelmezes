function isInLeft = determineRegion1v1(sD, xA, nu, perimeter)
% INPUT
% sD: A védett terület határát leíró függvény paraméter, mely az adott védő
% pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% isInLeft: Igaz, ha a támadó a vizsgált védőhöz tartozó bal régióban
% helyezkedik el és hamis, ha nem.

sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);

s_DL = arcLen(sD, sL, perimeter);
[gamma_sL,~] = pointOnPerimeter(sL,perimeter);
s_RD = arcLen(sR, sD, perimeter);
[gamma_sR,~] = pointOnPerimeter(sR,perimeter);

JL_star = s_DL - (norm(gamma_sL - xA))/(nu);
JR_star = s_RD - (norm(xA - gamma_sR))/(nu);

sD_opp = opposite(sD,perimeter);
SL = [sD, sD_opp];
SR = [sD_opp, sD];

cond1_in = isin(sL,SL,[1 1]);
cond2_in = isin(sR,SR,[1 1]);

if (cond1_in && cond2_in && (JL_star > JR_star)) || ...
    (cond1_in && ~cond2_in) || ...
    (~cond1_in && ~cond2_in && (JL_star < JR_star))

    isInLeft = true;
else
    isInLeft = false;
end


