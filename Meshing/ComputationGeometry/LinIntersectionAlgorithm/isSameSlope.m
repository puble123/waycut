function [tf] = isSameSlope(p,q,r,s,tol)

m11 = GetSlope(p,q);
m12 = GetSlope(q,p);
m21 = GetSlope(r,s);
m22 = GetSlope(s,r);

if isinf(m11) && isinf(m21)

    tf = true;
    return
    
end

tf = norm(m11-m21) < tol || norm(m11-m22) < tol || norm(m12-m21) < tol...
    || norm(m12-m22) < tol;

end

