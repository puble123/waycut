function [idB,iLeaveing]  = RatioTest(h,xB,idxB,tol)

idp = find(h>tol); %B indexing

if isempty(idp)
    idB = []; 
    iLeaveing =[];
    disp("문제가 비유계입니다.");
end

% calculate ratio
ratio = xB(idp)./h(idp);

% min ratio
[mr,~] = min(ratio);

% min ratio와 동일한 index를 구함.
i  = find(ratio==mr); % i는 ratio의 인덱스

% 최소비율이 같은 경우 낮은 인덱스를 고름.
[iLeaveing,ii] = min(idxB(idp(i)));
idB = idp(i(ii));

end
