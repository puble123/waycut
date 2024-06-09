function [mesh] = GenerateHedgeTriStructuredMesh(bbox,gsize,tol)

% 정규 격자를 활용한 구조화된 정규 격자 생성
[vertices,conns] = GenerateTriStructuredMesh(bbox,gsize,tol);
%triplot(conns,vertices(:,1),vertices(:,2),"Color","k");

% 구조화된 정규 격자를 Half-edge 데이터 구조로 전환
[mesh] = ConvertTriStructuredMesh2HalfEdge(vertices,conns);

end