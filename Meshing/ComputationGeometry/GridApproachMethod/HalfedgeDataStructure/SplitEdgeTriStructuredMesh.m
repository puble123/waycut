function [mesh,hedge] = SplitEdgeTriStructuredMesh(mesh,vertices,edges,bbox,gsize,tol)

% 갯수 세기
nee   = size(edges,1);
nvv   = size(vertices,1);
nhe   = length(mesh.hep);
nhv   = length(mesh.hve);

% 박스 y축 인덱스 최대 값(박스 인덱스에 필요)
jmax = GetRegularBoxIndexYmax(bbox,gsize,tol);

% origin point
po   = mesh.hvc(1,:);

% 삭제 엣지
dele  = [];

% for문으로 시작
for ide = 1:nee

    % 우선순이 큐에 추가
    queue = ide;

    while true

        %while문을 빠져나올 문장
        if isempty(queue)
            break
        end

        % 선입선출,사용 후 제거
        idse = queue(1);
        queue(1) = [];

        % 시작/끝점
        sa = vertices(edges(idse,1),:);
        ea = vertices(edges(idse,2),:);

        % 라인이 지나가는 박스 검출
        idhes = GetHedgeIndexOfIntersectionLine(mesh,jmax,po,sa,ea,gsize,tol);
            
        % for문으로 실제 겹치는 라인 검출
        for ide = 1:length(idhes)

            % 반직선
            idce = idhes(ide);
            idte = mesh.het(idce);

            % 포인트
            sb   = mesh.hvc(mesh.hev(idce),:);
            eb   = mesh.hvc(mesh.hev(idte),:);

            % 겹치는가?
            [tf] = isIntersect(sa,ea,sb,eb);
            
            % 겹치지 않는 경우엔 넘어가.
            if ~tf
                continue;
            end
            
            co = isSameSlope(sa,ea,sb,eb,tol);

            if co % colienar 인 경우
                
                % 지울 모서리가 필요함.
                u = [];
                
                % 삭제 엣지 인덱스 추가
                dele  = [dele; idse];

                % t는 무시하고 u1, u2만 구한다.
                [~,u1] = CalBzsierParameter(sa,sa,sb,eb,tol);
                [~,u2] = CalBzsierParameter(ea,ea,sb,eb,tol);

                % u1, u2에 추가함.
                if tol < u1 && u1 < 1-tol

                    u = u1;

                end

                if tol < u2 && u2 < 1-tol

                    u = [u;u2];

                end

                % 점 하나만 추가하는 경우
                if norm(u2-u1)<tol && length(u)==2

                    u = u1;

                end

                % sorting하여 순서를 결정
                [u,~] = sort(u);
                
                % 선택 엣지
                idct = idce;
                idtt = idte;

                % 두 개 / 한 개 / 0 개 점을 삽입
                for i = 1:length(u)

                    uu = u(i);

                    % 트윈 엣지
                    idcn = mesh.hen(idct);
                    idtn = mesh.hen(idtt);

                    % 정점 추가
                    mesh.hvc(nhv+1,:) = sb + uu*(eb-sb);
                    mesh.hve(nhv+1) = nhe+1;

                    % 엣지 추가
                    mesh.hev(nhe+1:nhe+2) = nhv+1;
                    mesh.het(nhe+1:nhe+2) = [idtt,idct];
                    mesh.hef(nhe+1:nhe+2) = mesh.hef([idct,idtt]);
                    mesh.hep(nhe+1:nhe+2) = [idct,idtt];
                    mesh.hen(nhe+1:nhe+2) = [idcn,idtn];

                    % 엣지 업데이트
                    mesh.het([idct,idtt]) = [nhe+2,nhe+1];
                    mesh.hen([idct,idtt]) = [nhe+1,nhe+2];
                    mesh.hep([idcn,idtn]) = [nhe+1,nhe+2];

                    % 갯수 업데이트
                    nhv = nhv+1;
                    nhe = nhe+2;

                    % 두개일때 순서를 결정하여 현재 반직선결정
                    idct = nhe-1;
                    idtt = mesh.het(idct);

                end
            else

                % 둘다 정점이 삽입이 가능한 경우
                [t,u] = CalBzsierParameter(sa,ea,sb,eb,tol);

                if tol < u && u < 1-tol
                    
                    % 트윈 엣지
                    idcn = mesh.hen(idce);
                    idtn = mesh.hen(idte);
                    
                    % 정점 추가
                    mesh.hvc(nhv+1,:) = sb + u*(eb-sb);
                    mesh.hve(nhv+1) = nhe+1;
                    
                    % 엣지 추가
                    mesh.hev(nhe+1:nhe+2) = nhv+1;
                    mesh.het(nhe+1:nhe+2) = [idte,idce];
                    mesh.hef(nhe+1:nhe+2) = mesh.hef([idce,idte]);
                    mesh.hep(nhe+1:nhe+2) = [idce,idte];
                    mesh.hen(nhe+1:nhe+2) = [idcn,idtn];
                    
                    % 엣지 업데이트
                    mesh.het([idce,idte]) = [nhe+2,nhe+1];
                    mesh.hen([idce,idte]) = [nhe+1,nhe+2];
                    mesh.hep([idcn,idtn]) = [nhe+1,nhe+2];
                    
                    % 갯수 업데이트
                    nhv = nhv+1;
                    nhe = nhe+2;

                end

                if tol < t && t < 1-tol

                    % 정점 추가
                    vertices(nvv+1,:) = sa + t*(ea-sa);

                    % 모서리 연결 수정
                    temp = edges(idse,2);
                    edges(idse,2) = nvv+1;
                    edges(nee+1,:) = [nvv+1,temp];

                    % 큐에 삽입
                    queue = [queue; idse; nee+1];

                    % 추가 모서리 및 정점 수 추가
                    nvv = nvv+1;
                    nee = nee+1;
                    break

                end

            end

        end

    end

end

% 정점 삽입 후 X축 정렬(202309021339 추가)
[mesh.hvc, index] = sortrows(mesh.hvc);
mesh.hve = mesh.hve(index);
[~, jndex] = sort(index);
mesh.hev(:) = jndex(mesh.hev);

% Colinear 모서리 삭제 및 재 인덱싱 
edges(dele,:) = [];
tfv = false(size(vertices,1),1);
tfv(reshape(edges,[],1)) = true;
rid = ReIndexing(tfv);
vertices = vertices(tfv,:);
edges    = rid(edges);

% edge를 half-data structure로 변환
[hedge] = ConvertEdge2Hedge(vertices,edges);

end






