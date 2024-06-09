function [h] = DrawingHedge(ax,hedge,elist,varargin)

edges = nan(length(elist),2);

for id = 1:length(elist)
    eid = elist(id);
    edges(id,1) = hedge.hev(eid);
    edges(id,2) = hedge.hev(hedge.het(eid));
end

[h] = DrawingEdge(ax,hedge.hvc,edges,1:length(elist),varargin{:});

end