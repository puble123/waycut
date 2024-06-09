function [conns] = MakeConnlistStructuredMesh(rxdata,rydata)

% 격자 갯수
nrx = length(rxdata);
nry = length(rydata);

% 미리할당
conns = nan(4*(nrx-1) * (nry-1),3); 
 
% conn의 규칙을 활용해서 미리 v라는 벡터 임시 연결리스트를 생성해둠
v = [1, 2, 2 * nry, 2 * nry + 1];
tconn = nan(4, 3);
tconn(:, 1) = nry + 1;
tconn(:, 2) = v;
tconn(:, 3) = v([3, 1, 4, 2]);

% 연결리스트 업데이트
row = 1;
for i = 1:(nrx - 1)

    for j = 1:(nry - 1)

        e = row + 3;
        conns(row:e, :) = tconn;
        row = row + 4;
        tconn = tconn + 1;

    end

    tconn = tconn + nry;
    
end
end