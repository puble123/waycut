function [vertices,conns] = GenerateTriStructuredMesh(bbox,gsize,tol)

% 정규 격자를 구성하는 x, y coordinate.
[rxdata,rydata] = GetRegularGridPointdata(bbox,gsize,tol);

% 삼각 분할을 구성하는 연결리스트와 정점리스트를 생성
% x축 정렬. x 값이 동일하면 y 축 정렬.
[vertices] = MakeVerticesStructuredMesh(rxdata,rydata,gsize); 

% 세개의 정점으로 구성. CCW 방향으로 연결리스트를 구성. (매트랩 역시 세개의 정점으로 구성)
[conns]    = MakeConnlistStructuredMesh(rxdata,rydata);     
end