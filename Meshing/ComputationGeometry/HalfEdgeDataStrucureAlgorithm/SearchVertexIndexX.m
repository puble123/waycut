function [idmin,idmax] = SearchVertexIndexX(vertices,vertex,l,r,tol)

if l > r

    idmin = -1;
    idmax = -1;
    return

end

mid = floor((l+r)/2);
dif = vertices(mid,1) - vertex(1);

if abs(dif) <= tol

    for down = mid-1:-1:1

        if abs(vertex(1)-vertices(down,1)) > tol

            idmin = down+1;
            break

        end

    end

    for up = mid+1:+1:size(vertices,1)

        if abs(vertex(1)-vertices(up,1)) > tol

            idmax = up-1;
            break

        end

    end

    return

end

if dif < 0

    [idmin, idmax] = SearchVertexIndexX(vertices, vertex, mid + 1, r, tol);

else
    
    [idmin, idmax] = SearchVertexIndexX(vertices, vertex, l, mid - 1, tol);

end

end
