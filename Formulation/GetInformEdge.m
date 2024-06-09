function [len,ang] = GetInformEdge(vert1,vert2)

vec = (vert2-vert1);

len = norm(vec);

ang = atan2d(vec(2),vec(1));

ang = mod(ang+180,180);

end

