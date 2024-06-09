function [c,A,b,idxB] = BigM(c,A,b,idxB)

[m,n] = size(A);

% Big M method
M = 1000;

% 0을 새로 추가
c = [c;0]; 

% A 제약조건 추가
idxN = (1:size(A,2))';
idxN(idxB) = [];
A = [A,zeros(m,1)];
A = [A;ones(1,n+1)];
A(m+1,idxB) = 0;

% big M 추가
b(m+1) = M;

% Basis list에 새로 추가한 기저변수를 추가
idxB(end+1) = (n+1);

% LU decomposition
dB = decomposition(A(:,idxB),'lu');

% step0 Compute xb = B^-1*b
xB = dB\b;

% step1 Pricing
zN = c(idxN) - A(:,idxN)'*(c(idxB)'/dB)';

% step2 finding min reduced price
[~,idN] = min(zN);

% step3 교환
idxB(m+1) = idxN(idN);

disp("[ BigM ] Finding Initial Infeasible Solution")

end