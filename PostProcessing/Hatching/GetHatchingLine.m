function [vertices,edges] = GetHatchingLine(mesh,bedge,sway,way,width,tol)

vertices = [];
edges = [];

for i = 1:length(bedge)

    % 정보
    ang = way(sway(mesh.hef(bedge{i}(1))));
    bbox = GetBoundaryBox(mesh.hvc(mesh.hev(bedge{i}),:));

    % 한점을 지나가야할 때
    pnt  = bbox([1,3]);

    % 박스를 채우는 해칭라인 생성 
    [hatv,hate] = GetHatchingBasicLine(bbox,ang,width,pnt);

    % 해칭라인
    [hatv,hate] = SplitHatchingEdge(mesh,bedge{i},hatv,hate,tol);
    
    n = size(vertices,1);
    
    vertices = [vertices; hatv];
    edges    = [edges; n + hate];


end

end