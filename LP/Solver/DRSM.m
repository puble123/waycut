function [xval,fval,yval,zval] = DRSM(c,A,b,idxB,tol)

n = size(A,2);

xval = zeros(n,1);
zval = zeros(n,1);

idxN = (1:n)';
idxN(idxB) = [];



while true

    B = A(:,idxB);
    N = A(:,idxN);

    % Compute inverse matrix
    invB = inv(B);

    % Compute basis variable
    xB = invB * b;
    xB(abs(xB)<tol) = 0;

    % basis variable
    xval(idxB) = xB;
    xval(idxN) = 0;

    % Compute lamda
    yval = (c(idxB)'*invB)';

    % Compute reduced price
    zN = c(idxN) - N'*yval;
    zN(abs(zN)<tol) = 0;

    % dual variable
    zval(idxB) = 0;
    zval(idxN) = zN;

    % cal cost
    fval = dot(c,xval);

    % 종료조건
    if all(xB>=0)
        % BigM으로 추가되었던 것을 제거
        xval(end) = [];
        yval(end) = [];
        zval(end) = [];
        return
    end

    % leaving variable
    r = find(xB==min(xB));
    [ileav,rr] = min(idxB(r));
    idB = r(rr);

    % Compute Hrn
    hrn = (invB(idB,:) * N)';
    hrn(abs(hrn)<tol) = 0;
    idNs = find(hrn<0);

    if isempty(idNs)
        disp("문제가 불가능합니다.");
        xval = []; yval = []; zval = []; fval = [];
        return
    end

    % calculate ratio
    ratio = -zN(idNs)./hrn(idNs);
    [p,~] = min(ratio);
    ids = find(ratio==p);
    [ientr,i] = min(idxN(idNs(ids)));
    idN = idNs(ids(i));

    % swap index
    idxB(idB) = ientr;
    idxN(idN) = ileav;

    h = invB * A(:,ileav);
    h(abs(h)<tol) = 0;

    if all(h<=0)
        disp("문제가 비유계입니다.");
        xval = []; yval = []; zval = []; fval = [];
        return
    end

end



end