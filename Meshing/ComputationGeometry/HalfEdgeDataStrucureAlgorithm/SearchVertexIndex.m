function [indx] = SearchVertexIndex(vertices,vertex,tol)

r = size(vertices,1);
l = 1;

[idmin,idmax] = SearchVertexIndexX(vertices,vertex,l,r,tol);

if idmin < 0

    indx = -1;
    return
    
end

[indx] = SearchVertexIndexY(vertices,vertex,idmin,idmax,tol);

end