function SaveFigBar(b,way,fn,iter)

Nd = length(way);


for i = 1:Nd
    ax = b(i).Parent;
    filename = fn + "\" + "iter" + string(iter) + "Dir" + string(way(i)) + ".png";
    exportgraphics(ax,filename,"Resolution",300);
end
end