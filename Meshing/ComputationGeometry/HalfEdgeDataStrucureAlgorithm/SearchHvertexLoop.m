function [idhes] = SearchHvertexLoop(hedge,idev,tf,maxiter)

if nargin < 4

    maxiter = 3000;

    if nargin == 2

        tf = true;

    end

end

idce = hedge.hve(idev);
idse = idce;
idhes = idce;

while true


    if tf

        idce = hedge.het(hedge.hep(idce));

    else

        idce = hedge.hen(hedge.het(idce));

    end

    if idce == idse

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