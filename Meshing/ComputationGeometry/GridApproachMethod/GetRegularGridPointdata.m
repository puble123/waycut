function [rxdata,rydata] = GetRegularGridPointdata(bbox,gsize,tol)

sx = floor(bbox(1)/gsize)*gsize; %start x;

if bbox(1) - sx < tol

    sx = sx-gsize;

end

sy = floor(bbox(3)/gsize)*gsize; %start y

if bbox(3) - sy < tol

    sy = sy-gsize;

end

ex = ceil(bbox(2)/gsize)*gsize;  %end x;

if ex - bbox(2) < tol
    
    ex = ex+gsize;

end

ey = ceil(bbox(4)/gsize)*gsize;  %end y;

if ey - bbox(4) < tol
    
    ey = ey+gsize;

end

rxdata = (sx:gsize:ex)'; %사각형을 구성하는 점 x
rydata = (sy:gsize:ey)'; %사각형을 구성하는 점 y

end