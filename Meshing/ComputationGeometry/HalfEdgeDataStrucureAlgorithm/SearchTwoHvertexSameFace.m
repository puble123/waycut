function [idf,indx,jndx] = SearchTwoHvertexSameFace(hedge,idv1,idv2)

idf = [];
indx= [];
jndx =[];

idhes1 = SearchHvertexLoop(hedge,idv1);
idhes2 = SearchHvertexLoop(hedge,idv2);


idhfs1 = hedge.hef(idhes1);
idhfs2 = hedge.hef(idhes2);


for i = 1:length(idhes1)

    for j = 1:length(idhes2)

        if idhfs1(i) == idhfs2(j)

            idf  = [idf;  idhfs1(i)];
            indx = [indx; idhes1(i)];
            jndx = [jndx; idhes2(j)];

        end

    end
    
end

end