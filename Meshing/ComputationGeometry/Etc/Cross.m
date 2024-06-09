function [val] = Cross(p,q)

% X-Y 평면 벡터에 대한 외적(Z축 벡터의 크기)
val = p(1) * q(2) - p(2) * q(1);

end

