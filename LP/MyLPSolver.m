function [xval,fval,yval,zval] = MyLPSolver(c,A,b,solver,tol)

% 사다리꼴 행렬, 독립행/열 선택
[A,b,~,infeasible] = MakeEchelonForm(A,b);

if infeasible
    error("Infeasible 문제입니다.");
end

if solver == "PRSM"
    
    [idxB] = Phase1(A,b,tol);
    [xval,fval,yval,zval] = PRSM(c,A,b,idxB,tol);

elseif solver == "DRSM"

    [idxB] = Phase1(A,b,tol);
    [c,A,b,idxB] = BigM(c,A,b,idxB);
    [xval,fval,yval,zval] = DRSM(c,A,b,idxB,tol);
    
elseif solver == "MPCM"

    [xval,fval,yval,zval] = MPCM(c,A,b,tol);

elseif solver == "BM"

    [xval,fval,yval,zval] = BM(c,A,b,tol);

else

    error("옵션을 다시 선택해주세요.");

end

end

