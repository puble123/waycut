function [indx] = SearchVertexIndexY(vertices,vertex,l,r,tol)

if l > r

    indx = -1;
    return

end

mid = floor((l+r)/2);
dif = vertices(mid,2) - vertex(2);

if abs(dif) <= tol

    indx = mid;    
    return

elseif dif < 0

    [indx] = SearchVertexIndexY(vertices, vertex, mid + 1, r, tol);

else

    [indx] = SearchVertexIndexY(vertices, vertex, l, mid - 1, tol);

end

end