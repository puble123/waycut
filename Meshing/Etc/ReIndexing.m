function [reid] = ReIndexing(tf)

n = sum(tf);
v = 1:n;
% 변수를 미리 할당
reid = nan(n,1);
% rid(tf)에 순차적으로 1부터 n까지 입력하여 연속된 색인을 생성.
reid(tf) = v;

end