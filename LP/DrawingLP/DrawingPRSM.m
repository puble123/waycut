function [xval,fval,yval,zval] = DrawingPRSM(fn,mesh,Ie,way,c,A,b,idxB,tol)

iter = 0;
n = size(A,2);

xval = zeros(n,1);
zval = zeros(n,1);

idxN = (1:n)';
idxN(idxB) = [];

% Drawing 관련 함수들
[val,sway] = DecisionDirection(mesh,Ie,xval,way);
[H1] = DrawingDir(mesh,way,sway);
[B1] = DrawingBar(mesh,way,sway,val);

fval = dot(c,xval);

while true

    pval = fval;
    iter = iter +1;

    % LU분해에 대한 전위(Preordering)으로 유용
    idxB = idxB(colperm(A(:,idxB)));

    % LU decomposition
    dB = decomposition(A(:,idxB),'lu');

    % step0 Compute xb = B^-1*b
    xB = dB\b;
    xB(abs(xB)<=tol) = 0;

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
    zN(abs(zN)<=tol) = 0;

    zval(idxN) = zN;
    zval(idxB) = 0;
    fval = c'*xval;
        
    if abs(pval-fval) > tol

        % Drawing 관련 함수들 
        [val,sway] = DecisionDirection(mesh,Ie,xval,way);
        UpdateDir(H1,mesh,way,sway);
        UpdateBar(B1,mesh,way,sway,val);

        temp = H1.Parent;
        title(temp,string(fval));
        SaveFigDir(H1,fn,iter);
        SaveFigBar(B1,way,fn,iter);

        drawnow();
    end
    
    if all(zN > -tol)
        fprintf("[Pahse2] Finding Optimal Solution\n");
        return
    end

    %swap indexing(pivot rule)
    [idN,iEntering] = Dantzig(zN,idxN);
    %[idN,iEntering] = Bland(zN,idxN,tol);

    d = dB\A(:,iEntering);

    [idB,iLeaveing] = RatioTest(d,xB,idxB,tol);

    if isempty(idxB)
        fprintf("Finding Unbounded Solution\n");
        xval=[]; yval=[]; zval=[];
        return
    end

    idxN(idN) = iLeaveing;
    idxB(idB) = iEntering;
    
end
end
