function [vert,conn] = GetDefualtBar(mesh)

% 면의 갯수
Nf = length(mesh.hfe);

% 정점과 연결리스트
vert = zeros(6*Nf,3);
conn = nan(5*Nf,5);

% 연결리스트 더미
dummy = ...
    [
         1,      3,      2,      1,    nan;
    3*Nf+1, 3*Nf+3, 3*Nf+2, 3*Nf+1,    nan;
    3*Nf+1, 3*Nf+3,      3,      1, 3*Nf+1;
    3*Nf+2,      2,      1, 3*Nf+1, 3*Nf+2;
    3*Nf+3,      3,      2, 3*Nf+2, 3*Nf+3;
    ];

for idf = 1:Nf
    
    % Face를 구성하는 모서리 루프 탐색
    idhes  = SearchHfaceLoop(mesh,idf);

    % 높이가 있는 정점
    vert(3*(idf-1)+1:3*idf,1:2) = mesh.hvc(mesh.hev(idhes),:);
    vert(3*(idf-1)+1:3*idf,3)   = 1e-6;

    % 높이가 없는 정점
    vert(3*(Nf+idf-1)+1:3*(Nf+idf),1:2) = mesh.hvc(mesh.hev(idhes),:);
    
    % 연결리스트
    conn(5*(idf-1)+1:5*idf,:) = dummy;

    % 연결리스트 업데이트
    dummy = dummy+3;

end

end