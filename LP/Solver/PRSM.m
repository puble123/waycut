function [xval,fval,yval,zval] = PRSM(c,A,b,idxB,tol)

iter = 0;
n = size(A,2);

xval = zeros(n,1);
zval = zeros(n,1);

idxN = (1:n)';
idxN(idxB) = [];

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
        fprintf("Finding Infeasible Solution\n");
        xval=[]; yval=[]; zval=[]; fval = [];
        return
    end

    % step1 Pricing
    yval = (c(idxB)'/dB)';
    zN = c(idxN) - A(:,idxN)'*yval;
    zval(idxN) = zN;
    zval(idxB) = 0;

    if all(zN > -tol)
        fprintf("[Pahse2] Finding Optimal Solution\n");
        fval = c'*xval;
        return
    end


    %swap indexing
    [idN,iEntering] = Bland(zN,idxN,tol);

    h = dB\A(:,iEntering);

    [idB,iLeaveing] = RatioTest(h,xB,idxB,tol);

    if isempty(idxB)
        fprintf("Finding Unbounded Solution\n");
        xval=[]; yval=[]; zval=[];
        return
    end

    idxN(idN) = iLeaveing;
    idxB(idB) = iEntering;

end
end
