function [i,j] = GetIntBoxIndex(ov,v1,v2,gsize,tol)

% csp, cep는 gsize와 원점을 op로 하는 계수 값
csp = (v1 - ov) / gsize;
cep = (v2 - ov) / gsize;

% x축 정렬되어야 함. => swap되는 경우
if(csp(1) > cep(1)) || ((csp(1) == cep(1)) && (csp(2) > cep(2)))

    temp = csp;
    csp = cep;
    cep = temp;

end

% 기울기 m과 y축 절편 b를 계산
if abs(cep(1) - csp(1)) > tol

    m = (cep(2)-csp(2))/(cep(1)-csp(1));
    b = (csp(2)-m*csp(1));

else

    m = inf;

end

% 올림으로 정수화 x축 기준으로 탐색.
x = ceil(csp(1)):ceil(cep(1));

% y1과 y2 box 위치를 계산
y1 = ceil(csp(2));
y2 = ceil(cep(2));

% 만약 x축으로 변화가 없는 경우, y로만 계산
if length(x) == 1

    % 위로만 쌓는다.
    if m > 0 || isinf(m)

        % y로만 계산
        y = y1:y2;

    else

        % y로만 계산
        y = y2:y1;
        
    end

    ny = length(y);
    i = x * ones(ny,1);
    j = y';

    return
end

nx = length(x);
i = [];
j = [];

for k = 1:nx
    
    % X축 변화가 생긴 경우 다시 Y값을 계산하여 박스 인덱스를 구한다.
    if k ~= 1

        dp = ceil(GetY(m,b,x(k-1)));

    else

        dp = ceil(y1);

    end

    % X축 변화가 생긴 경우 다시 Y값을 계산하여 박스 인덱스를 구한다.
    if k ~=nx

        dn = ceil(GetY(m,b,x(k)));

    else

        dn = ceil(y2);

    end

    % X를 항상 -> 방향으로
    if m > 0
       
        y = dp:dn;

    else

        y = dn:dp;

    end


    ny = length(y);
    i = [i; x(k)*ones(ny,1)];
    j = [j; y'];

end

end

