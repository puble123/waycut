function [tf] = isIntersect(p1,q1,p2,q2)

% CCW/CW를 계산하는 함수.
o1 = GetOrientation(p1,q1,p2);
o2 = GetOrientation(p1,q1,q2);
o3 = GetOrientation(p2,q2,p1);
o4 = GetOrientation(p2,q2,q1);

% 일단 false를 기본으로 함.
tf = false;

% General case
if (o1 ~= o2 && o3 ~= o4)

    tf = true;
    return;

end

% Special Cases
% p1, q1 and p2 are collinear and p2 lies on segment p1q1
if (o1 == 0 && isOnSegment(p1,p2,q1))

    tf = true;
    return;

end

% p1, q1 and q2 are collinear and q2 lies on segment p1q1
if (o2 == 0 && isOnSegment(p1,q2,q1))

    tf = true;
    return;

end

% p2, q2 and p1 are collinear and p1 lies on segment p2q2
if (o3 == 0 && isOnSegment(p2,p1,q2))

    tf = true;
    return;

end

% p2, q2 and q1 are collinear and q1 lies on segment p2q2
if (o4 == 0 && isOnSegment(p2,q1,q2))

    tf = true;
    return;

end

end