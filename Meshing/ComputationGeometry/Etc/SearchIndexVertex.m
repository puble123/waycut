function [indexs] = SearchIndexVertex(vertices,vertex,tol)

% 벡터 크기
ilow = 1;
ihig = size(vertices,1);

% X값이 허용 오차 이내 값이 동일한 경우
[index1] = SearchBinaryRecursiveTol(vertices(:,1),vertex(1),ilow,ihig,tol);

% X 탐색 과정에서 없는 경우
if index1 == -1
    indexs = -1;
    return
end

% Y값이 허용 오차 이내 값이 동일한 경우
[index2] = SearchBinaryRecursiveTol(vertices(index1,2),vertex(2),1,length(index1),tol);

% Y 탐색 과정에서 없는 경우
if index2 == -1
    indexs = -1;
    return
end

indexs = index1(index2);

end