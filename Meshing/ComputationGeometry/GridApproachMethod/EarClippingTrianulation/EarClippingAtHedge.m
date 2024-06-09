function [adde] = EarClippingAtHedge(hedge)

% 추가해야할 모서리
adde = [];

% face마다 점이 세개 이상이면 삼각분할을 실시
for idf = 1:length(hedge.hfe)

    % 면을 구성하는 모서리 탐색
    idhes = SearchHfaceLoop(hedge,idf);

    % 모서리의 시작점들
    vlist = hedge.hev(idhes);

    % 삼각형인 경우 넘어감
    if length(vlist) == 3

        continue;

    end

    % EarClippingAlgorithm으로 삼각분할을 실시
    adde = [adde; EarClipping(hedge,vlist)];

end

end