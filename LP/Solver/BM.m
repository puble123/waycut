function [xval,fval,yval,zval] = BM(c,A,b,tol)

mu = 100;

n = length(c);

% short step algorithm
%gamma = (8*n)/(8*n+sqrt(n));
gamma = 0.9;

d = (1:n)';

e = ones(n,1);

% 초기 점
[xval,yval,zval] = InitialPoint(c,A);
if all(abs(A*xval - b) > tol)
    error("[Error]: 초기점 설정 오류.");
end

while true

    if mu < tol
        return
    end

    % 촐로스키분해
    X = sparse(d,d,xval);
    S = X*X;
    [R,p] = chol(A*S*A');

    if p
        return
    end

    % netwon method
    rh =  A*S*c - mu*A*X*e;
    yval = R\(R'\rh);
    zval = c - A'*yval;

    % netwon direction
    dx = (1/mu) * (S*A'*(yval)+mu*X*e-S*c);

    % step length
    id = find(dx<0);
    ap = 0.995*min([-xval(id)./dx(id);1]);

    % update solution
    xval = xval + ap*dx;

    fval = dot(xval,c) - mu * sum(log(xval));

    mu = mu * gamma;

end

end