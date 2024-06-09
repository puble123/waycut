function [adde] = EarClipping(hedge,vlist)

% 추가되어야 할 모서리
adde = [];

% vlist가 3개만 남을때 까지
while true

    % 남아있는 정점의 수
    nv = length(vlist);

    % 3개만 남은 경우 삼각형을 형성하기 때문에 모서리 추가 불필요
    if nv == 3

        return

    end

    % 정점의 수만큼 탐색
    for i = 1:nv

        % 연속한 세 점의 인덱스
        if i == 1

            idp1 = vlist(end);
            idp3 = vlist(i+1);

        elseif i == nv

            idp1 = vlist(i-1);
            idp3 = vlist(1  );

        else

            idp1 = vlist(i-1);
            idp3 = vlist(i+1);

        end
        idp2 = vlist(i);

        %세 점이 이루는 삼각형 내 점 판별
        if isConvex(hedge.hvc(idp1,:),hedge.hvc(idp2,:),hedge.hvc(idp3,:))
            
            % Ear(귀/모퉁이)를 형성할 수 있는 경우
            isEar = true;

            % 다각형을 구성하는 점 중 삼각형 내에 포함된 점이라면?
            % 모퉁이를 형성할 수 없음.
            for j = 1:nv

                if idp1 == vlist(j) || idp2 == vlist(j) || idp3 == vlist(j)
                    
                    % 세 점에 포함된 경우에는 계산하지 않고 넘어감
                    continue;

                end
               
                % 세 점에 포함되지 않는 다각형의 점이 삼각형 내에 포함되는지 판별
                if isTriInPoint(hedge.hvc(idp1,:),hedge.hvc(idp2,:),hedge.hvc(idp3,:),hedge.hvc(vlist(j),:))

                    % 포함하는 경우 모퉁이 불가
                    isEar = false;
                    break

                end

            end

            % 모퉁이를 형성하는 경우 잘라낼 수 있음
            if isEar
    
                % 모서리 추가
                adde = [adde; idp1, idp3]; %모퉁이 점의 이웃점을 연결
                vlist(i) = []; %모퉁이 점 삭제
                break; %for문 탈출

            end

        end

    end

end

                
                
