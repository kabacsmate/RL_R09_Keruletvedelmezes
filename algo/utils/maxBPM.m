function matchR = maxBPM(bpGraph)
[M,N] = size(bpGraph);
matchR = zeros(1,N);

for u=1:M
    seen = false(N,1);
    bpm(u,seen);
end

    function res = bpm(u,seen)
    for v=1:N
        if bpGraph(u,v) && ~seen(v)
            seen(v) = true;
            if matchR(v) == 0 || bpm(matchR(v),seen)
                matchR(v) = u;
                res = true;
                return
            end
        end
    end
    res = false;
    end
end