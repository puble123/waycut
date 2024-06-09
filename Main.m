%% 초기화
clc; clear(); close("all");

%% 경로 설정
MyPathManager;

%% 다각형 불러오기
[vertices,edges] = Polygon("g2",[0;100;0;100],false,false,1e-10);

%% 반직선 데이터 구조 기반 mesh 생성
[mesh] = MyTriMesh(vertices,edges,1,1e-6,true);
DrawingHface(gca,mesh,1:size(mesh.hfe),"color","blue");

%% 문제 구성
[Ie] = GetEdgeOrderPair(mesh);
[c,A,b] = MakeProblem(mesh,Ie,[0,45,90,135],"Kimyh");

%% 문제 풀이
tf = false;
if tf == true
    [xval,fval,yval,zval] = DrawingMyLPSolver(mesh,Ie,[0,45,90,135]...
        ,c,A,b,"BM",1e-10);
else
    [xval,fval,yval,zval] = MyLPSolver(c,A,b,"BM",1e-10);
end

[h,b] = PostProcessing(mesh,Ie,xval,[0,45,90,135],2,1e-6);


