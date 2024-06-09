function [jmax] = GetRegularBoxIndexYmax(bbox,gsize,tol)

% 정규 격자를 구성하는 y 값을 구함
[~,rydata] = GetRegularGridPointdata(bbox,gsize,tol);
jmax = length(rydata)-1;

end
