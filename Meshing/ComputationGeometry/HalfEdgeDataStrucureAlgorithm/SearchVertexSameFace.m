function [fid,idhe1,idhe2] = SearchVertexSameFace(hedge,v1,v2)

fid = [];
idhe1 = [];
idhe2 = [];

idhes1 = SearchHvertexLoop(hedge,v1);
idhes2 = SearchHvertexLoop(hedge,v2);

fids1 = hedge.het(idhes1);
fids2 = hedge.het(idhes2);

for i = 1:length(fids1)

    for j = 1:length(fids2)

        if fids1(i) == fids2(j)

            fid = fids1(i);
            idhe1 = idhes1(i);
            idhe2 = idhes2(j);
            return

        end

    end

end

end