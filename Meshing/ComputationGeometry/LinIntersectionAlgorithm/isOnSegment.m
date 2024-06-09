function tf = isOnSegment(p,q,r)

if (r(1) <= max(p(1), q(1)) && r(1) >= min(p(1), q(1)) && ...
        r(2) <= max(p(2), q(2)) && r(2) >= min(p(2), q(2)))
    
    tf = true;

else

    tf = false;

end

end