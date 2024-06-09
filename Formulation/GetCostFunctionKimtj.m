function [cost] = GetCostFunctionTJ(mesh,IE,way)

% 갯수
Nd = length(way);
Ne = size(IE,1);
Nf = length(mesh.hfe);

% 비용함수
cost = nan(Nd*Nd*Ne,1);

for ide = 1:Ne

    % 모서리의 길이, 각도 정보
    [Lij,tij] = GetInformEdge(mesh.hvc(mesh.hev(IE(ide,1)),:)...
        ,mesh.hvc(mesh.hev(IE(ide,2)),:));
    tpq = mod(way-tij+180,180);

    s = Nd*Nd*(ide-1);

    for p = 1:Nd

        for q = 1:Nd

            % 경계 셀인 경우 (i < j) => 2번째를 확인하면 알 수 있음
            if mesh.hef(IE(ide,2)) > Nf

                % 해당 면의 공구 경로 상태에 대한 Flux를 계산
                cost(s+Nd*(p-1)+q) = Lij*sind(tpq(p));
                
            else
                
                % 경계 셀이 아닌경우
                if p == q
                    
                    cost(s+Nd*(p-1)+q) = 0;

                else
                    
                    % 두 면의 공구 경로 상태에 대한 Flux를 계산
                    cost(s+Nd*(p-1)+q) = Lij*(sind(tpq(p))+sind(tpq(q)));

                end
                
            end
            
        end

    end

end

end
            