function [tf,on] = isInPoly(vertices,edges,qverts,tol)

[vertices,index] = sortrows(vertices);
[~,jndex] = sort(index);
edges = jndex(edges);

nvrt = size(qverts,1);
nedg = size(edges,1);

tf = false(nvrt,1);
on = false(nvrt,1);

% x축 정렬
tfswap = edges(:,1) > edges(:,2);
edges(tfswap,:) = edges(tfswap,[2,1]);

for ide = 1 : nedg

    % vertcies의 인덱스
    inod = edges(ide,1);
    jnod = edges(ide,2);

    % Bounding Box
    x1 = vertices(inod,1);
    y1 = vertices(inod,2);
    x2 = vertices(jnod,1);
    y2 = vertices(jnod,2);
    
    % 최소 최대값
    ymin = min(y1,y2)-tol;
    ymax = max(y1,y2)+tol;
    xmin = x1 - tol;
    xmax = x2 + tol;

    % box
    dx = x2 - x1;
    dy = y2 - y1;

    % 오차를 포함한 box
    edel = dx + abs(dy);

    ilow = +1;
    iupp = nvrt;

    % Binary Search
    while (ilow < iupp -1)

        imid = ilow + floor((iupp-ilow)/2);

        if (qverts(imid,1) < xmin)

            ilow = imid;

        else

            iupp = imid;

        end

    end

    if (qverts(ilow,1) >= xmin)

        ilow = ilow - 1;

    end

   for jndex = ilow+1 : nvrt

       if on(jndex)

           continue;

       end

       xval = qverts(jndex,1);
       yval = qverts(jndex,2);

       if xval <= xmax

           if yval >= ymin
               
               if yval <= ymax
        
                   mul1 = dx * (yval - y1);
                   mul2 = dy * (xval - x1);

                   if ((eps*edel) >= abs(mul2-mul1) || ...
                           xval == x1 && yval == y1 && ...
                           xval == x2 && yval == y2)
                       
                       tf(jndex) = true;
                       on(jndex) = true;

                   elseif (mul1 < mul2)
                       
                       if (xval >= x1 && xval < x2)

                           tf(jndex) = ~tf(jndex);

                       end

                   end

               end

           else

               if ( xval >= x1 && xval < x2)

                   tf(jndex) = ~tf(jndex);

               end

           end

       else

           break;

       end

   end

end

end






           

