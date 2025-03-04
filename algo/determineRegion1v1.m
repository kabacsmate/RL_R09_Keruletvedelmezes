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

isInLeft = 0;