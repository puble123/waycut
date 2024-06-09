function [xval,fval,yval,zval] = DrawingMyLPSolver(mesh,Ie,way,c,A,b,solver,tol)

% 사다리꼴 행렬, 독립행/열 선택
[A,b,~,infeasible] = MakeEchelonForm(A,b);

if infeasible
    error("Infeasible 문제입니다.");
end

t = string(datetime('now','TimeZone','local','Format','yyyyMMddHHmmss'));
fn = "SaveFigure\" + t;
mkdir(fn);

if solver == "PRSM"
    
    [idxB] = Phase1(A,b,tol);
    [xval,fval,yval,zval] = DrawingPRSM(fn,mesh,Ie,way,c,A,b,idxB,tol);

elseif solver == "DRSM"

    [idxB] = Phase1(A,b,tol);
    [c,A,b,idxB] = BigM(c,A,b,idxB);
    [xval,fval,yval,zval] = DrawingDRSM(fn,mesh,Ie,way,c,A,b,idxB,tol);
    
elseif solver == "MPCM"

    [xval,fval,yval,zval] = MPCM(c,A,b,tol);

elseif solver == "BM"

    [xval,fval,yval,zval] = BM(c,A,b,tol);

else

    error("옵션을 다시 선택해주세요.");

end

end