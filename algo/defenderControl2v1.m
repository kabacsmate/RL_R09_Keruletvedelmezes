function [wD1,wD2] = defenderControl2v1(sD1,sD2,xA,nu,perimeter)
% INPUT
% sD1: A védett terület határát leíró függvény paraméter, mely az első védő
% pozícióját jelöli.
% sD1: A védett terület határát leíró függvény paraméter, mely a második 
% védő pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% wD1: Az 1. védekező beavatkozó jele, mely a kerület menti sebesség. Pozitív
% előjel esetén ccw, negatív előjel esetén cw mozgást eredményez.
% wD2: A 2. védekező beavatkozó jele, mely a kerület menti sebesség. Pozitív
% előjel esetén ccw, negatív előjel esetén cw mozgást eredményez.
is_in_RD1 = isInRD(sD1,xA,nu,perimeter);
is_in_RD2 = isInRD(sD2,xA,nu,perimeter);
if is_in_RD1
    wD1 = defenderControl1v1(sD1,xA,nu,perimeter);
    wD2 = 0;
elseif is_in_RD2
    wD1 = 0;
    wD2 = defenderControl1v1(sD2,xA,nu,perimeter);
else
    sL = leftBreachingPoint(xA, nu, perimeter);
    sR = rightBreachingPoint(xA, nu, perimeter);
    is_in_D1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
    if is_in_D1D2
        wD1 = 1;
        wD2 = -1;
    else
        wD1 = -1;
        wD2 = 1;
    end
end