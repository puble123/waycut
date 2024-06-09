function CheckPolygon(vertices,edges,geomtol)

arguments
    vertices    (:,2)   double
    edges       (:,2)   uint64
    geomtol     (1,1)   double
end

% 모서리 갯수
Ne = size(edges,1);

for i = 1:Ne-1

    sa = vertices(edges(i,1),:);
    ea = vertices(edges(i,2),:);
    
    for j = i+1:Ne
        
        sb = vertices(edges(j,1),:);
        eb = vertices(edges(j,2),:);

        [tf] = isIntersect(sa,ea,sb,eb);

        if ~tf
            continue;
        end

        co = isSameSlope(sa,ea,sb,eb,geomtol);

        if co
           
            [~,u1] = CalBzsierParameter(sa,sa,sb,eb,geomtol);
            [~,u2] = CalBzsierParameter(ea,ea,sb,eb,geomtol); 
            [t1,~] = CalBzsierParameter(sa,ea,sb,sb,geomtol);
            [t2,~] = CalBzsierParameter(sa,ea,eb,eb,geomtol);
            
            if (geomtol < u1 && u1 < 1-geomtol) ...
                || (geomtol < u2 && u2 < 1-geomtol) ...
                || (geomtol < t1 && t1 < 1-geomtol) ...
                || (geomtol < t2 && t2 < 1-geomtol)

                error("[Error] 교차하는 모서리가 있습니다.");
            end

        else
            
            [t,u] = CalBzsierParameter(sa,ea,sb,eb,geomtol);

            if (geomtol < t && t < 1-geomtol) ...
                    || (geomtol < u && u < 1-geomtol)
                
                error("[Error] 교차하는 모서리가 있습니다.");

            end

        end

    end

end

end










