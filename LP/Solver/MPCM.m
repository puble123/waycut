function [xval,fval,yval,zval] = MPCM(c,A,b,tol)

% 행렬 사이즈
[~,cmax] = size(A);

% 초기 점
[xval,yval,zval] = InitialPoint(c,A);


% 세팅값
iter = 0;     %횟수
etaM = 0.995; %여유분
rows = (1:cmax);
cols = (1:cmax);

% Mehrota's Predictor-corrector algorithm
while true

    % 잔차 계산
    rd = (A'*yval + zval - c); %쌍대
    rp = (A*xval - b); %원
    rc = (xval.*zval); %상대

    % Mu값(평균값)
    mu = sum(rc)/cmax;

    % 종료 조건
    if max([mu,norm(rp),norm(rd)]) <= tol
        break
    end

    D = sparse(rows,cols,xval./zval);
    M = A * D * A';
    [R,p] = chol(M); %촐로스키분해를 사용함.

    if p > 0
        break
    end

    % 예측자
    rhs = rp - A * ((rc - xval .* rd) ./ zval);
    dy = R \ (R' \ rhs);
    dz = rd - A' * dy;
    dx = (rc-xval.* dz) ./ zval;

    Ap = 1/max([1;dx./xval]);
    Ad = 1/max([1;dz./zval]);

    % 센터링
    mun = (xval-Ap*dx)'*(zval-Ad*dz)/cmax;
    sigma = (mun/mu)^3; % 이부분은 조정이 가능함.

    % 수정자
    rc = rc - sigma * mu + dx.*dz;
    rhs = rp - A * ((rc - xval.* rd) ./ zval);

    % Newton direction
    dy = R \ (R' \ rhs);
    dz = rd - A'*dy;
    dx = (rc - xval.*dz)./zval;

    % step length
    eta = max(etaM,1-mu);
    Ap  = eta/max([eta;dx./xval]);
    Ad  = eta/max([eta;dz./zval]);
    
    % Update
    xval = xval-Ap*dx;
    yval = yval-Ad*dy;
    zval = zval-Ad*dz;

    fval = dot(c,xval);

    iter = iter + 1;
end
end


