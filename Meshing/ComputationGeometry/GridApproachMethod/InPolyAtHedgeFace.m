function [hedge] = InPolyAtHedgeFace(hedge,vertices,edges,tol,op)

% 폴리곤
[vertices,i] = sortrows(vertices);
[~,j] = sort(i);
edges = j(edges);
swap  = edges(:,1) > edges(:,2);
edges(swap,:) = edges(swap,[2,1]);

% 폴리곤 In/out 판별 
[tff] = isOnOffFace(hedge,vertices,edges,tol,op);

% 인덱스를 바꿀 때 사용 2 - > 1 (바꿀 인덱스가 저장됨)
idface = nan(length(hedge.hfe),1); %face 인덱스 바꿀 때 사용.
idedge = nan(length(hedge.hef),1);
idvert = nan(length(hedge.hve),1);

% PolyGon 내부 face를 구성하는 모서리
tfe = false(length(hedge.hev),1);
tfv = false(length(hedge.hve),1);
for idf = 1:length(hedge.hfe)

    idhes = SearchHfaceLoop(hedge,idf);
    idhts = hedge.het(idhes);

    if tff(idf)

        tfe([idhes;idhts]) = true;
        tfv(hedge.hev([idhes;idhts])) = true;
        hedge.hve(hedge.hev([idhes;idhts])) = [idhes;idhts];

    end
    
end

% 저장할 인덱스 저장
idface(tff) = 1:sum(tff);
idedge(tfe) = 1:sum(tfe);
idvert(tfv) = 1:sum(tfv);

% face 제거
hedge.hfe = hedge.hfe(tff);

% face - edge의 edge 인덱스 변환
hedge.hfe = idedge(hedge.hfe);

% edge 제거 및 모서리 인덱스 변환
hedge.hev = hedge.hev(tfe);
hedge.het = hedge.het(tfe);
hedge.hef = hedge.hef(tfe);
hedge.hep = hedge.hep(tfe);
hedge.hen = hedge.hen(tfe);

% edge - edge 모서리 인덱스 변환
hedge.het = idedge(hedge.het);
hedge.hep = idedge(hedge.hep);
hedge.hen = idedge(hedge.hen);

% edge - face 면 인덱스 변환
hedge.hef = idface(hedge.hef);

% vertex 제거
hedge.hvc = hedge.hvc(tfv,:);
hedge.hve = hedge.hve(tfv,:);

% vertex - edge 인덱스 변환
hedge.hve = idedge(hedge.hve);

% edge - vertex 인덱스 변환
hedge.hev = idvert(hedge.hev);

% 외곽의 연결리스트 업데이트
idhes = find(isnan(hedge.hen));
for id = 1:length(idhes)

    idhce = idhes(id);

    idv = hedge.hev(hedge.het(idhce));

    % 좋은 생각이 나지 않아서.. logn사용
    idqhes = SearchIndexBinary(hedge.hev,idv);
    
    for ide = 1:length(idqhes)

        idqhe = idqhes(ide);
        
        if isnan(hedge.hep(idqhe))
            
            idhne = idqhe;
            break

        end
           
    end

    hedge.hep(idhne) = idhce;
    hedge.hen(idhce) = idhne;

end



end