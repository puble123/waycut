function [idhes] = SearchHedgeLoop(hedge,idhe,tf,maxiter)

if nargin < 4
    maxiter = 3000;
    if nargin == 2
        tf = true;
    end
end

idhes = idhe;
idce  = idhe;

while true 

    if  tf
        idce = hedge.hen(idce);
    else
        idce = hedge.hep(idce);
    end
    
    if idce == idhe
        return
    end
    
    idhes = [idhes;idce];
    
    maxiter = maxiter - 1;
    
    if maxiter == 0
        error("모서리 기준 루프 탐색 과정에서 " + ...
            "함수가 최대 수행을 넘어섰습니다.\n",maxiter)
    end

end
end
