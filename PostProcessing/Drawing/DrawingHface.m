function [h] = DrawingHface(ax,hedge,flist,varargin)

[h] = line(ax,[nan;nan],[nan;nan]);
set(h,varargin{:});

XDAta = [];
YDAta = [];

for idf = 1:length(flist)
    
    idhes = SearchHfaceLoop(hedge,flist(idf));
    
    for i = 1:length(idhes)
        XDAta = [XDAta; hedge.hvc(hedge.hev(idhes(i)),1)];
        YDAta = [YDAta; hedge.hvc(hedge.hev(idhes(i)),2)];
    end
    
    XDAta = [XDAta; hedge.hvc(hedge.hev(idhes(1)),1); nan];
    YDAta = [YDAta; hedge.hvc(hedge.hev(idhes(1)),2); nan];
    
end

 set(h,"XDAta",XDAta,"YDAta",YDAta);

end