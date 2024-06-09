function [indx] = SearchInsertIndex(s,t)
% 정렬된 벡터 s에 값을 삽입할 위치를 찾습니다.

% 벡터 s가 비어있는 경우 항상 1번 인덱스에 삽입합니다.
if isempty(s)
    indx = 1;
    return;
end

% 이진 탐색을 사용하여 값을 삽입해야 할 위치를 찾습니다.
left = 1;
right = length(s);

while left <= right
    mid = floor((left + right) / 2);

    % t와 중간 요소를 비교합니다.
    if t == s(mid)
        indx = mid; % 중복 값을 찾았으므로 중간 인덱스를 반환합니다.
        return;
    elseif t < s(mid)
        right = mid - 1;
    else
        left = mid + 1;
    end
end

% 이진 탐색이 끝난 후, t를 삽입해야 하는 위치를 반환합니다.
indx = left;
end