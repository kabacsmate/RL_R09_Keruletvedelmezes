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

sL = leftBreachingPoint(xA, nu, perimeter);
sR = rightBreachingPoint(xA, nu, perimeter);
smid = middlePointOnPerimeter(sD1, sD2, perimeter);

[gamma_sL,~] = pointOnPerimeter(sL,perimeter);
[gamma_sR,~] = pointOnPerimeter(sR,perimeter);
[gamma_smid,~] = pointOnPerimeter(smid,perimeter);


is_in_D1D2 = relevantRegion2v1(sD1,sD2,xA,nu,perimeter);
if is_in_D1D2
    sDi = sD1;
    sDj = sD2;
else
    sDi = sD2;
    sDj = sD1;
end

Sd = [sDi, smid];
closed = [1,0];

in_Ri = isin(sL,Sd,closed);

Sd =[smid,sDj];
closed =  [0,1];
in_Rj = isin(sR,Sd,closed);

if in_Ri
    uA = nu*(gamma_sL-xA)/norm(gamma_sL-xA);
elseif in_Rj
    uA = nu*(gamma_sR-xA)/norm(gamma_sR-xA);
else
    uA = nu*(gamma_smid-xA)/norm(gamma_smid-xA);
end
