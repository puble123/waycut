function [vert,edge] = SplitHatchingEdge(mesh,idhes,hatv,hate,tol)

Ne = size(hate,1);
Nhe = length(idhes);
qe = (1:Ne)';

vert = hatv;
edge = hate;

while ~isempty(qe)

    % 제거를 위한 bool
    dtf = false;

    % Brute-force algorithm
    for id = 1:Nhe

        % Free boundary edge
        idce = idhes(id);
        idte = mesh.het(idce);

        % Free boundary edge -> vertex
        sa   = vert(edge(qe(1),1),:);
        ea   = vert(edge(qe(1),2),:);
        sb   = mesh.hvc(mesh.hev(idce),:);
        eb   = mesh.hvc(mesh.hev(idte),:);

        % interesction
        [tf] = isIntersect(sa,ea,sb,eb);

        % 둘 중 하나라도 true면 true
        dtf = dtf || tf;

        % 교차하면,
        if tf

            % colinear
            co = isSameSlope(sa,ea,sb,eb,tol);

            % Colinear가 아닌 경우 vertex 추가.
            if ~co

                [t] = CalBzsierParameter(sa,ea,sb,eb,tol);

                if t > tol && t < 1-tol

                    % 정점 추가
                    vert(end+1,:) = sa + t*(ea-sa);

                    % 모서리 연결 수정
                    edge(end+1,2) = edge(qe(1),2);
                    edge(end,1) = size(vert,1);
                    edge(qe(1),2) = size(vert,1);

                    qe(end+1) = qe(1);
                    qe(end+1) = size(edge,1);

                    break

                end


            end


        end

    end

    % 선입선출
    qe(1) = [];

end

% 다각형을 구성하는 정점
dummye = [(1:2:2*length(idhes))', (2:2:2*length(idhes))'];
dummyv = zeros(2*length(idhes),2);
dummyv(1:2:end,:) = mesh.hvc(mesh.hev(idhes),:);
dummyv(2:2:end,:) = mesh.hvc(mesh.hev(mesh.het(idhes)),:);

Ne = size(edge,1);
Nv = size(vert,1);

tfe = false(Ne,1);
tfv = false(Nv,1);

for ide = 1:Ne

    % 중심점
    qverts = (vert(edge(ide,1),:) + vert(edge(ide,2),:))/2;

    % point in polygon
    [tf,on] = isInPoly(dummyv,dummye,qverts,tol);

    if tf && ~on

        tfe(ide) = true;
        tfv(edge(ide,:)) = true;

    end

end

vid = ReIndexing(tfv);
vert = vert(tfv,:);
edge = vid(edge(tfe,:));

if size(edge,2) == 1
    edge = edge';
end

end