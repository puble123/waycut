function [vertices,edges] = GetHatchingBasicLine(bbox,ang,width,pnt)

u = [cosd(ang) sind(ang)];

if ang < 90
    v = [-sind(ang) +cosd(ang)];
else
    v = [+sind(ang) -cosd(ang)];
end

% v방향으로 얼만큼 간격을 증가시킬지.
w = width * v;
magw = abs(w);

if magw(1) ~= 0 
    bbox(1) = pnt(1) - ceil(abs(pnt(1)-bbox(1))/magw(1))*magw(1);
    bbox(2) = pnt(1) + ceil(abs(pnt(1)-bbox(2))/magw(1))*magw(1);
end

if magw(2) ~= 0
    bbox(3) = pnt(2) - ceil(abs(pnt(2)-bbox(3))/magw(2))*magw(2);
    bbox(4) = pnt(2) + ceil(abs(pnt(2)-bbox(4))/magw(2))*magw(2);
end


dx = bbox(2) - bbox(1);
dy = bbox(4) - bbox(3);


if ang == 0
    sv = bbox([1,3])';
    d  = dx;
    Nl = ceil(dy/width);
elseif ang < 90
    sv = bbox([1,3])' - dx * sind(ang) * v;
    d  = abs(dx) * abs(cosd(ang)) + abs(dy) * abs(sind(ang));
    Nl = ceil(abs(d)/width);
elseif ang == 90
    sv = bbox([1,3])';
    d  = dy;
    Nl = ceil(dx/width);
else
    sv = bbox([1,3])' - dx * sind(ang-90) * u;
    d  = abs(dy) * abs(cosd(ang)) + abs(dx) * abs(sind(ang));
    Nl = ceil(abs(d)/width);
end

ev = sv + d * u;
vertices = [sv; ev];



for i = 1:Nl

    sv = sv + width * v;
    ev = sv + d * u;
    vertices = [vertices; sv; ev];

end

edges = [(1:2:size(vertices,1))',(2:2:size(vertices,1))'];


end