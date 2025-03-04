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

res = 0;
J = 0;