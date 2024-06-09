function m = GetSlope(p,q)

if (p(1) == q(1))

    % 동일한 X값이면 기울기는 inf임.
    m = Inf;

else
    
    % 기울기 계산하는 식
    m = (q(2)-p(2)) / (q(1)-p(1));

end

end