function [mesh] = ConvertTriStructuredMesh2HalfEdge(vertices,conns)

% 삼각 구조화된 메시를 HalfEdge데이터 구조로 바꾸는 함수.
% 입력 갯수
nv = 1*size(vertices,1);
nf = 1*size(conns,1);
ne = 3*nf; %삼각형을 구성하는 엣지는 3개이다.

% 정점 데이터
mesh.hvc = vertices;
mesh.hve = nan(nv,1);

% 모서리 데이터
mesh.hev = nan(ne,1);
mesh.het = nan(ne,1);
mesh.hef = nan(ne,1);
mesh.hep = nan(ne,1);
mesh.hen = nan(ne,1);

% 면 데이터
mesh.hfe = nan(nf,1);

% for문으로 연결리스트를 채움
for idf = 1:nf

    % start index(face를 기준으로 입력함)
    s = 3*(idf-1)+1;

    % 모서리 연결리스트 
    mesh.hev(s:s+2) = conns(idf,:);
    mesh.hef(s:s+2) = idf;
    mesh.hep(s:s+2) = [s+2,s,s+1]; 
    mesh.hen(s:s+2) = [s+1,s+2,s]; 
    
    % 면 연결리스트
    mesh.hfe(idf)   = s;

    % vertex-edge data update
    for idte = 0:2
        
        if isnan(mesh.hve(mesh.hev(s+idte))) % nan인경우 삽입
            
            mesh.hve(mesh.hev(s+idte)) = s+idte;

        end

    end

end

% X 축 정렬
[mesh.hev,i] = sortrows(mesh.hev); %순서바꾸기
[~,j] = sortrows(i); %인덱스 바꾸기

% 순서와 인덱스 바꾸기
mesh.hef = mesh.hef(i);
mesh.hep = j(mesh.hep(i));
mesh.hen = j(mesh.hen(i));
mesh.hve = j(mesh.hve);
mesh.hfe = j(mesh.hfe);

% Twin Edge 업데이트
vec = mesh.hev;
out = [];

for idce = 1:ne

    % het가 채워져 있는 경우 수행하지 않음.
    if ~isnan(mesh.het(idce))
        continue;
    end

    % 다음의 엣지
    idsv = mesh.hev(idce);
    idev = mesh.hev(mesh.hen(idce));

    % 동일 정점에서 출발하는 엣지들
    [indxs] = SearchIndexBinary(vec,idev);
    %[indxs] = SearchSortedVector(vec,idev,1,ne,1e-6);

    % 모서리를 구성하는 두 정점이 모두 동일한 경우 Twin이다.
    id = find(mesh.hev(mesh.hen(indxs))==idsv,1);
    idte = indxs(id);

    % Twin이 없는 경우 HalfEdge를 추가해야함.
    if isempty(idte)
    
        % 외곽 엣지와 Twin을 구성하는 경우 out에 추가
        out = [out;idce];

    else

        % Twin Edge Upate
        mesh.het(idce) = idte;
        mesh.het(idte) = idce;

    end

end

% 외곽 엣지 추가
no = length(out);
idce = out(1);

for i = 1:no
       
    idev = mesh.hev(idce);
    idsv = mesh.hev(mesh.hen(idce));
    
    % 끝점이 지금의 시작점이다.
    mesh.hev(end+1) = idsv;
    
    % 해당 엣지의 twin은 idce
    mesh.het(idce)  = ne + i;
    mesh.het(end+1) = idce;
    mesh.hep(end+1) = ne + i + 1;
    mesh.hen(end+1) = ne + i - 1;
    mesh.hef(end+1) = nan; % face는 nan(외곽 face)

    % 동일 출발 모서리 탐색(logN)
    [indxs] = SearchIndexBinaryRecursive(vec,idsv,1,ne);
    %[indxs] = SearchSortedVector(vec,idsv,1,ne,1e-6);
    id = find(isnan(mesh.het(indxs)),1); %동일 출발 모서리는 하나임.
    idce = indxs(id);

end

% 외곽 모서리를 구성하는 시작 모서리와 끝 모서리 데이터 수정 
mesh.hen(ne+1) = ne+no;
mesh.hep(end)  = ne+1;

end

