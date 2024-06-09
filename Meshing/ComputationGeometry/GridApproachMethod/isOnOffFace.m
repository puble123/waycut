function [tf] = isOnOffFace(hedge,vertices,edges,tol,op)

nf = length(hedge.hfe);
tf = true(nf,1);

for idf = 1:nf
    
    idhes = SearchHfaceLoop(hedge,idf);
    idhvs = hedge.hev(idhes);
    verts = hedge.hvc(idhvs,:);
    if op
        qvert = sum(verts./3);
    else
        qvert = sortrows(verts);
    end
    tf(idf) = all(isInPoly(vertices,edges,qvert,tol));

end