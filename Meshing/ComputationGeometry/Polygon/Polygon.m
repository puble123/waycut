function [vertices,edges] = Polygon(filename,boxlim,isdraw,issave,geomtol)

arguments
    filename            string
    boxlim      (4,1)   double
    isdraw      (1,1)   logical
    issave      (1,1)   logical
    geomtol     (1,1)   double
end

fn = "SavePolygon\"+string(filename)+".mat";

% 그리기 옵션에 따라 다각형 생성 또는 불러오기
if isdraw

    [vertices,edges] = InputPolygon(boxlim);

else
    
    if exist(fn,"file")

        load(fn,"vertices","edges");

    else

        vertices = [];
        edges = [];

    end

    if isempty(vertices) || isempty(edges)
        
        error("파일 이름이나 사용하고자 하는 matfile 내부 변수를 확인해보세요.");
    
    end

end

% 저장 옵션에 따라 데이터 저장
if issave

    edges = uint64(edges);
    save(fn,"vertices","edges");
    
end

% 중복되지 않도록
[vertices,~,ic] = unique(vertices,"rows","stable");
edges = ic(edges);

% 확인
CheckPolygon(vertices,edges,geomtol);

end