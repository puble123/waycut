function [index] = SearchSameIndex(s,t)
% 정렬된 벡터 s에서 값을 이진 검색을 사용하여 찾습니다.

left = 1;
right = length(s);

while left <= right
    mid = floor((left + right) / 2);

    if s(mid) == t
        index = mid;
        return;
    elseif s(mid) < t
        left = mid + 1;
    else
        right = mid - 1;
    end
end

% 값을 찾지 못한 경우 빈 배열을 반환합니다.
index = [];
end