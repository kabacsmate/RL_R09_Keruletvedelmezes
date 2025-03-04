function wD = defenderControl1v1(sD, xA, nu, perimeter)
% INPUT
% sD: A védett terület határát leíró függvény paraméter, mely az adott védő
% pozícióját jelöli.
% xA: Az adott támadó pozíciója (x,y) koordinátákban.
% nu: A védő és támadó maximális sebességeinek hányadosát megadó paraméter.
% perimeter: A védett területet leíró struktúra.

% OUTPUT
% wD: A védekező beavatkozó jele, mely a kerület menti sebesség. Pozitív
% előjel esetén ccw, negatív előjel esetén cw mozgást eredményez.

wD = 0;