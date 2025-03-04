function sol = myFsolve(fun,x0,upperLimit,options)
        [sol,~,exitflag] = fsolve(fun,x0,options);
        if exitflag <= 0 || sol < 0 || upperLimit < sol
            x0 = mod(x0 + 1,upperLimit);
            sol = myFsolve(fun,x0,upperLimit,options);
        end
end