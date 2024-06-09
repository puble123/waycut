function [idxB] = Phase1(A,b,tol)

[m,n] = size(A);

idminus = b<0;
d = (1:m);
v = ones(1,m);
v(idminus) = -1;

% 새로운 문제 구성
B = sparse(d,d,v);
A = [A,B];
c = [zeros(n,1);ones(m,1)];

idxB = (n+1:n+m)';
idxN = (1:n)';

iter = 0;

xval = zeros(n+m,1);
yval = zeros(m,1);
zval = zeros(n+m,1);


while true

    iter = iter +1;

    % 열변환
    q = colperm(A(:,idxB));
    idxB = idxB(q);

    % LU decomposition
    dB = decomposition(A(:,idxB),'lu');

    % step0 Compute xb = B^-1*b
    xB = dB\b;
    xval(idxB) = xB;
    xval(idxN) = 0;

    if any(xB < -tol)
        disp("문제가 실현 불가능합니다.");
        xval=[]; yval=[]; zval=[]; fval = [];
        return
    end

    % step1 Pricing
    yval = (c(idxB)'/dB)';
    zN = c(idxN) - A(:,idxN)'*yval;
    zval(idxN) = zN;
    zval(idxB) = 0;

    if all(zN > -tol)
        disp("[Phase1] Finding Intial Feasible Solution.");
        return
    end


    %swap indexing
    [idN,iEntering] = Dantzig(zN,idxN);
    %[idN,iEntering] = Bland(zN,idxN,tol);

    h = dB\A(:,iEntering);
    
    [idB,iLeaveing] = RatioTest(h,xB,idxB,tol);

    if isempty(idxB)
        fprintf("문제가 비유계입니다.");
        xval=[]; yval=[]; zval=[];
        return
    end

    idxN(idN) = iLeaveing;
    idxB(idB) = iEntering;

end


end






