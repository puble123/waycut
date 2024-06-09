function [mesh,qf] = MergeEdgeTriStructuredMesh(mesh,poly,tol)

% Poly의 반직선 데이터 구조 갯수
nhpv = length(poly.hve); %half edge data strucutre poly의 정점 갯수
nhpe = length(poly.hen); %half edge data strucutre poly의 모서리 갯수

% Mesh의 반직선 데이터 구조 갯수
nhmv = length(mesh.hve); %half edge data strucutre poly의 정점 갯수
nhme = length(mesh.hen); %half edge data strucutre poly의 모서리 갯수
nhmf = length(mesh.hfe); %half edge data strucutre poly의 면 갯수

% 동일한 위치의 점을 통합
tfv  = true(nhpv,1);  %추가할 점 여부
rid  = zeros(nhpv,1); %점 인덱스
addv = 1;

qf = [];

for idpv = 1:nhpv

    %idmv = SearchIndexVertex(mesh.hvc,poly.hvc(idpv,:),tol); 20230923수정
    a = abs(mesh.hvc(:,1) - poly.hvc(idpv,1)) < tol;
    b = abs(mesh.hvc(:,2) - poly.hvc(idpv,2)) < tol;
    idmv = -1;

    for i = 1:length(a)
        if a(i) && b(i)
            idmv = i;
        end
    end

    if idmv == -1

        rid(idpv) = addv + nhmv;
        addv = addv + 1;
        continue;

    else

        tfv(idpv) = false;
        rid(idpv) = idmv;

    end

end


% 정점 수정
poly.hvc = poly.hvc(tfv,:);
poly.hve = poly.hve(tfv) + nhme;

% 모서리 수정
poly.hev = rid(poly.hev);
poly.het = poly.het + nhme;
poly.hep = poly.hep + nhme;
poly.hen = poly.hen + nhme;

% 정점 추가 및 정점 통합
mesh.hvc = [mesh.hvc; poly.hvc];
mesh.hve = [mesh.hve; poly.hve];

% 모서리 추가 및 정점
mesh.hev = [mesh.hev; poly.hev];
mesh.het = [mesh.het; poly.het];
mesh.hef = [mesh.hef; poly.hef];
mesh.hep = [mesh.hep; poly.hep];
mesh.hen = [mesh.hen; poly.hen];

% 모서리 연결리스트 업데이트
tfe = [false(nhme,1);true(nhpe,1)];
for idce = nhme+1:nhme+nhpe

    if ~tfe(idce)

        continue;

    end

    idv1 = mesh.hev(idce);

    % 연결이 불필요한 정점의 경우
    if idv1 > nhmv

        tfe(idce) = false;
        continue

    end

    % idce의 twin hedge
    idct = mesh.het(idce);

    % 연결 업데이트 실시
    tfe([idce,idct]) = false;

    idne = idce;
    idnt = mesh.het(idne);
    idv2 = mesh.hev(idnt);

    % 추가된 정점이 아닌 경우(연결이 불필요한 경우는 다음 정정점으로 넘어감)
    while idv2 > nhmv

        % 엣지와 정점 재설정
        idne = mesh.hen(idne);
        idnt = mesh.het(idne);
        idv2 = mesh.hev(idnt);

        % 연결 업데이트 실시 / 불필요한 경우
        tfe([idne,idnt]) = false;

    end

    [idf,idctn,idnen] = SearchTwoHvertexSameFace(mesh,idv1,idv2);

    if isempty(idf)

        error("공차 오류: 기하학적 공차를 줄여주세요!");

    end

    nf = length(idf);

    % 동시에 두개인 경우 face를 골라야함.
    if nf >= 2
        
        % 판별점
        xq = mesh.hvc(mesh.hev(mesh.hen(idce)),1);
        yq = mesh.hvc(mesh.hev(mesh.hen(idce)),2);

        for q = 1:nf

            % 면을 구성하는 모서리
            idhes = SearchHfaceLoop(mesh,idf(q));

            % 다각형을 구성하는 정점
            xv = mesh.hvc(mesh.hev(idhes),1);
            xv = [xv;xv(1)];
            yv = mesh.hvc(mesh.hev(idhes),2);
            yv = [yv;yv(2)];

            % 다각형 내부 점
            dummyv = [xv,yv];
            dummye = [(1:length(idhes))', [(2:length(idhes))';1]];
            [tf2] = isInPoly(dummyv,dummye,[xq,yq],tol);
            

            if tf2
    
                idf = idf(q);
                idctn = idctn(q);
                idnen = idnen(q);
                break

            end

            if q == nf

                idf = idf(q);
                idctn = idctn(q);
                idnen = idnen(q);
                break           

            end

        end

    end

    % 각각 이전 모서리 탐색
    idcep = mesh.hep(idctn);
    idntp = mesh.hep(idnen);

    % 연결리스트 업데이트
    mesh.hep([idce,idctn,idnt,idnen]) = [idcep,idct,idntp,idne];
    mesh.hen([idct,idcep,idne,idntp]) = [idctn,idce,idnen,idnt];

    % edge-face 업데이트
    [ides1] = SearchHedgeLoop(mesh,idce);
    mesh.hef(ides1) = idf;
    [ides2] = SearchHedgeLoop(mesh,idct);
    mesh.hef(ides2) = nhmf + 1;

    % face-edge 업데이트
    mesh.hfe([idf,nhmf+1]) = [idce,idnt];
    
    qf = [qf;idf;nhmf+1];

    % face 갯수 1 증가
    nhmf = nhmf + 1;

end

% X축 정렬 실시
[mesh.hvc, index] = sortrows(mesh.hvc);
mesh.hve = mesh.hve(index); %행 추출
[~, jndex] = sort(index); 
mesh.hev = jndex(mesh.hev); %색인 변환



end

