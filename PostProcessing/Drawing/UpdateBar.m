function UpdateBar(patch,mesh,way,sway,val)

Nd = length(way);
Nf = length(mesh.hfe);


for i = 1:Nd
   
    for idf = 1:Nf

        if sway(idf) == i

            patch(i).Vertices(3*(idf-1)+1:3*idf,3) = val(idf);
            

        else

            patch(i).Vertices(3*(idf-1)+1:3*idf,3) = 0;

        end

    end

end

end