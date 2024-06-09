function [idhes] = GetHedgeIndexOfIntersectionLine(mesh,jmax,ov,v1,v2,gsize,tol)

% 모서리가 지나가는 상자 색인을 계산하고 이를 메시 순서 계산
[i,j] = GetIntBoxIndex(ov,v1,v2,gsize,tol);
[idfs] = BoxIndex2FaceIndex(i,j,jmax);

% 박스를 구성하는 모서리 정보 행렬 생성
idhes = [];

% 면을 구성하는 모서리 
for id = 1:length(idfs)
    
    % 면을 구성하는 모서리 탐색
    idhes = [idhes; SearchHfaceLoop(mesh,idfs(id))];

end

% 모서리 정렬 
idhes = sort(idhes);

% 중복 모서리 삭제를 위한 index
i = 1;
n = length(idhes);

% 중복되지 않도록 모서리 삭제
while true
    
    if i >= n
        return
    end

    idhe = idhes(i);
    idht = mesh.het(idhe);

    [ind] = SearchIndexBinary(idhes,idht);

    if ind ~= -1

        idhes(ind) = [];
        n = n-1;

    end
    
    i = i+1;

end

end
