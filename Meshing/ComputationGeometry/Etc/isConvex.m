function [tf] = isConvex(p,q,r)

% pq, qr 벡터
pq = q - p;
qr = r - q;

% X-Y평면 두 벡터의 외적
val = Cross(pq,qr);

if val >= 0
    
    tf = true;

else

    tf = false;

end

end