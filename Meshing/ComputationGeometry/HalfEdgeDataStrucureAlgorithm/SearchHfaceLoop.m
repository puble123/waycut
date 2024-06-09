function [idhes] = SearchHfaceLoop(hedge,idf,tf,maxiter)

if nargin < 4

    maxiter = 3000;

    if nargin == 2

        tf = true;

    end

end

idhe = hedge.hfe(idf);
[idhes] = SearchHedgeLoop(hedge,idhe,tf,maxiter);

end