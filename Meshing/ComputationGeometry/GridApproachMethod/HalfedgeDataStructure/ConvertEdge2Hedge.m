function [hedge] = ConvertEdge2Hedge(vertcies,edges)

% 행렬의 크기 계산
nv = size(vertcies,1);
ne = size(edges,1);

% hv 관련 행렬 할당
hvc = vertcies;
hve = nan(nv,1);

% he 관련 행렬 할당
hev = nan(2*ne,1);
het = nan(2*ne,1);
hef = nan(2*ne,1);
hep = nan(2*ne,1);
hen = nan(2*ne,1);

% hf 관련 행렬 할당
hfe = [];

% vertex에 연결된 엣지 리스트
ev = nan(nv,2);

for ide = 1:ne
    for c = 1:2

        idv = edges(ide,c);

        if isnan(ev(idv,1))
            ev(idv,1) = ide;
        else
            ev(idv,2) = ide;
        end

    end
end

hev(:) = reshape(edges',2*ne,1);
het(1:2:end) = 2:2:2*ne;
het(2:2:end) = 1:2:2*ne;

for idv = 1:nv

    ea = ev(idv,1);
    eb = ev(idv,2);

    if isnan(ea)

        idea = nan;
        idta = nan;

    else
        if hev(2*ea-1) == idv

            idea = 2*ea-1;
            idta = 2*ea;

        else

            idea = 2*ea;
            idta = 2*ea-1;

        end
    end

    if isnan(eb)

        ideb = nan;
        idtb = nan;

    else
        if hev(2*eb-1) == idv

            ideb = 2*eb-1;
            idtb = 2*eb;

        else

            ideb = 2*eb;
            idtb = 2*eb-1;

        end
    end

    if ~isnan(idea)

        hep(idea) = idtb;
        hen(idta) = ideb;

    end

    if ~isnan(ideb)

        hep(ideb) = idta;
        hen(idtb) = idea;

    end

end

for ide = 1:2*ne

    idev = hev(ide);

    if isnan(hve(idev))

        hve(idev) = ide;

    end

end

hedge.hvc = hvc;
hedge.hve = hve;
hedge.hev = hev;
hedge.het = het;
hedge.hef = hef;
hedge.hep = hep;
hedge.hen = hen;
hedge.hfe = hfe;

end
