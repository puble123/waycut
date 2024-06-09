function [mesh] = MyTriMesh(vertices,edges,gsize,geomtol,isbmesh)

arguments

    vertices    
    edges
    gsize
    geomtol
    isbmesh

end

% 경계 상자 계산
[bbox] = GetBoundaryBox(vertices);

% 정규 격자를 활용한 삼각 메시 생성
[mesh] = GenerateHedgeTriStructuredMesh(bbox,gsize,geomtol);

if isbmesh

    % 메시와 모서리 분할
    [mesh,poly] = SplitEdgeTriStructuredMesh(mesh,vertices,edges,bbox,gsize,geomtol);

    % 분할된 메시와 모서리 병합
    [mesh] = MergeEdgeTriStructuredMesh(mesh,poly,geomtol);

    % 병합 과정에서 생긴 다각형의 삼각분할 -> Ear Clipping Algorithm 적용( N^2(O) 알고리즘 )
    [adde] = EarClippingAtHedge(mesh); %추가 모서리 계산
    [addhe]= ConvertEdge2Hedge(mesh.hvc,adde); %Half edge Data 구조 적용
    
    % 모서리 병합
    [mesh] = MergeEdgeTriStructuredMesh(mesh,addhe,geomtol);

end

% sorting
[mesh.hev, i] = sortrows(mesh.hev);

[~, j] = sortrows(i);

% edge 제거 및 모서리 인덱스 변환
mesh.het = j(mesh.het(i));
mesh.hef = mesh.hef(i);
mesh.hep = j(mesh.hep(i));
mesh.hen = j(mesh.hen(i));
mesh.hve = j(mesh.hve);
mesh.hfe = j(mesh.hfe);

% 폴리곤 내 다각형
[mesh] = InPolyAtHedgeFace(mesh,vertices,edges,geomtol,isbmesh);

% 면을 우선으로 함.
[dummy,i] = sortrows([mesh.hef, mesh.hef(mesh.het)]); %순서쌍때문에(nan를 뒤에 두기 위하여)
mesh.hef = dummy(:,1);
[~,j] = sort(i);
mesh.hev = mesh.hev(i);     %위치
mesh.het = j(mesh.het(i));  %위치 & 색인
mesh.hep = j(mesh.hep(i));  %위치 & 색인
mesh.hen = j(mesh.hen(i));  %위치 & 색인
mesh.hve = j(mesh.hve);     %색인
mesh.hfe = j(mesh.hfe);     %색인

idxs = find(isnan(mesh.hef));
mesh.hef(idxs) = length(mesh.hfe)+1:length(mesh.hfe)+length(idxs);

end