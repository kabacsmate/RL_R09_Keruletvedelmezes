function isInD1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter)
% INPUT
% sD1: A védett terület határát leíró függvény paraméter, mely az első védő
% pozícióját jelöli.
% sD1: A védett terület határát leíró függvény paraméter, mely a második 
% védő pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% isInD1D2: Igaz, ha a támadó az első védekezőtől a második védekezőig 
% bezárólag ccw irányban vizsgált térrészben helyezkedik el és hamis, ha 
% nem.

% TIPP
% A védett terület határának hosszát a perimeter(end).CumSum/2 utasítással
% érhetjük el.

is_in_Left1 = defenderControl1v1(sD1, xA, nu, perimeter);
is_in_Left2 = defenderControl1v1(sD2, xA, nu, perimeter);

s_D1D2 = arcLen(sD1, sD2, perimeter);
L = perimeter(end).CumSum;

if (round(s_D1D2, 3) < round(L/2, 3))
    isInD1D2 = ((is_in_Left1) && (~is_in_Left2));
else
    isInD1D2 = ((is_in_Left1) || (~is_in_Left2));
end


