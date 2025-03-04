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

wD1 = 0;
wD2 = 0;