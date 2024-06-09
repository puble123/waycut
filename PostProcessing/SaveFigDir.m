function SaveFigDir(h,fn,iter)

ax = h.Parent;

filename = fn + "\" + "iter" + string(iter) + ".png";

exportgraphics(ax,filename,"Resolution",300);

end