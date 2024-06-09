function [xval,yval,zval] = InitialPoint(c,A)

AA    = A*A';

cmax = length(c);

xval = zeros(cmax,1);

xval(:) = 1/16;

zval = ones(cmax,1);

yy = A * (c - zval);
yval = AA\yy;

end