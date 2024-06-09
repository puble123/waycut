function [indexs] = SearchIndexBinaryRecursive(vec,tag,low,hig)

if low > hig

    % 탐색 실패
    indexs = -1;
    return

end

mid = floor((low+hig)/2);

if vec(mid) == tag

    % 탐색 성공
    indexs = mid;

    % 중복된 값이 있는 경우 왼쪽 반 배열에서 더 찾음
    l = mid - 1;
    while l >= low && vec(l) == tag
        indexs = [l; indexs];
        l = l - 1;
    end

    % 중복된 값이 있는 경우 오른쪽 반 배열에서 더 찾음
    r = mid + 1;
    while r <= hig && vec(r) == tag
        indexs = [indexs; r];
        r = r + 1;
    end

    return

elseif vec(mid) < tag

    [indexs] = SearchIndexBinaryRecursive(vec,tag,mid+1,hig);

else

    [indexs] = SearchIndexBinaryRecursive(vec,tag,low,mid-1);

end

end
