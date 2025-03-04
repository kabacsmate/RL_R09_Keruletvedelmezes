function uA = intruderControl2v1(sD1,sD2,xA,nu,perimeter)
% INPUT
% sD1: A védett terület határát leíró függvény paraméter, mely az első védő
% pozícióját jelöli.
% sD1: A védett terület határát leíró függvény paraméter, mely a második 
% védő pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% uA: A támadó beavatkozó jele, mely egy sebességvektor.

uA = 0;