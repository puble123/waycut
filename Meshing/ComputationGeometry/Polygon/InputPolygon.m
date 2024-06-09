function [vertices,edges] = InputPolygon(boxlim)

% 그래프창 열고 세팅하기
fig = figure("Name","Input Polygon (Drawing)");
ax = axes(fig);
axis(ax,boxlim);
daspect(ax,[1,1,1]);
box(ax,"on");
hold(ax,"on");
grid(ax,"on");

% 임시 변수와 출력 변수 생성
tvertices = []; %임시 정점
vertices = [];  %다각형 정점
edges   = [];   %다각형 모서리

% 다각형의 정점 갯수
nv = 0;

% 라인 핸들 생성 
tl = line(ax);
set(tl,"Color","red","LineStyle",":","LineWidth",1.5,...
    "Marker","*","MarkerFaceColor","red","MarkerSize",3);

% 입력을 위한 While문 
while true

    % 클릭으로 하나의 점 입력
    [x,y] = ginput(1);

    % 축 제한 범위 이하로 입력받는다.
    if boxlim(1) <= x && x <= boxlim(2) && boxlim(3) <= y && y <= boxlim(4)

        % 제한 범위 이내인 경우 임시 변수에 저장
        tvertices(end+1,1:2) = [x,y];
        % 임시 변수에 저장된 정점 그래프에 표시
        set(tl,"XData",tvertices(:,1),"YData",tvertices(:,2));

    else

        % 임시 정점의 갯수 계산
        nt = size(tvertices,1);

        if nt < 3 && nt > 0

            % 하나라도 점을 선택했고, 삼각형 이상이어야 끝날 수 있음.
            continue;

        else
            
            if nt == 0

                % 임시 변수 내 정점이 0개면 종료할 수 있음.
                break
                
            end

            % 제한 범위 외 점을 입력받으면 종료한다.
            % 정점과 모서리 리스트에 입력
            vertices(nv+1:nv+nt,[1,2]) = tvertices;
            edges(nv+1:nv+nt,[1,2]) = [(nv+1:nv+nt)',([nv+2:nv+nt,nv+1])'];
            
            % 입력된 정점과 모서리 리스트를 그래프에 표시           
            DrawingEdge(ax,vertices,edges,1:size(edges,1),...
                "Color","black","LineStyle","-","LineWidth",3,...
                "Marker","o","MarkerFaceColor","black","MarkerSize",5);
            
            % 임시 데이터 재설정
            set(tl,"XData",[0;nan],"YData",[0;nan]);
            tvertices = [];
            
            % 총 정점의 개수 재설정
            nv = nv + nt;

        end

    end
    
end

% 종료되면 입력하던 창을 닫는다.
close(fig)

end
    