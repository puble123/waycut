function [indexs] = SearchBinaryRecursiveTol(vec,tag,low,hig,tol)

if low > hig

    indexs = -1;
    return

end

mid = floor((low+hig)/2);

if abs(vec(mid)-tag) < tol

    indexs = mid;

    % 중복된 값 찾기
    l = mid - 1;
    while l >= low && abs(vec(l)-tag) < tol
        indexs = [l; indexs];
        l = l - 1;
    end

    % 중복된 값 찾기
    r = mid + 1;
    while r <= hig && abs(vec(r)-tag) < tol
        indexs = [indexs; r];
        r = r + 1;
    end

    return
    
elseif vec(mid) < tag


    [indexs] = SearchBinaryRecursiveTol(vec,tag,mid+1,hig,tol);

else

    [indexs] = SearchBinaryRecursiveTol(vec,tag,low,mid-1,tol);

end

end
    
