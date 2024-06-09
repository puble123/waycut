function [h] = DrawingEdge(ax,vertices,edges,elist,varargin)

[h] = line(ax,"XDAta",[nan;nan],"YDAta",[nan;nan]);

% XDAta, YDAta 미리 할당
ne = length(elist);
XDAta = nan(3*ne,1);
YDAta = nan(3*ne,1);

% 모서리 별 X-좌표, Y-좌표를 XDAta, YDAta에 입력
XDAta(1:3:end) = vertices(edges(elist,1),1);
XDAta(2:3:end) = vertices(edges(elist,2),1);
YDAta(1:3:end) = vertices(edges(elist,1),2);
YDAta(2:3:end) = vertices(edges(elist,2),2);

% 라인 세팅
set(h,"XDAta",XDAta,"YDAta",YDAta,varargin{:});
end