function UpdateDir(h,mesh,way,sway)

Nd = length(way);

facelist = cell(Nd,1);

for idf = 1:length(sway)

    idhes = SearchHfaceLoop(mesh,idf);

    facelist{sway(idf)}(end+1,:) = mesh.hev([idhes;idhes(1)]);

end

for i = 1:Nd
    
    set(h(i),"Faces",facelist{i});

end

end