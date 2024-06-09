function [tf] = isTriInPoint(p,q,r,qp)

% https://3dmpengines.tistory.com/173
% 삼각형 내부/외부의 점 판별 코드
% 벡터
pq = q - p;
qr = r - q;
rp = p - r;

% 점까지 벡터
pqp = qp - p;
qqp = qp - q;
rqp = qp - r;

% 외적하여 법선 벡터의 방향이 달라지는지 계산
crosspq = Cross(pq,pqp);
crossqr = Cross(qr,qqp);
crossrp = Cross(rp,rqp);

% 법선 벡터의 방향이 일치하지 않는 경우 외부의 점
tf = ( crosspq >= 0 && crossqr >= 0 && crossrp >=0 ) || ...
    ( crosspq <= 0 && crossqr <= 0 && crossrp <=0  );

end