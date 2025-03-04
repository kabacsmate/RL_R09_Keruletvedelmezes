function in = isin(s,Sd,closed)
    if Sd(1) < Sd(2)
        if ( Sd(1) < s || (closed(1) && (Sd(1) == s)) ) && ...
           ( s < Sd(2) || (closed(2) && (Sd(2) == s)) )
            in = true;
        else
            in = false;
        end
    elseif ( Sd(1) < s || (closed(1) && (Sd(1) == s)) ) || ...
           ( s < Sd(2) || (closed(2) && (Sd(2) == s)) )
        in = true;
    else
        in = false;
    end