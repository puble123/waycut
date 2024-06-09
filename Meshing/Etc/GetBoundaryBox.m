function [bbox] = GetBoundaryBox(vertices)
 
bbox = nan(4,1);
bbox([1,3]) = floor(min(vertices))';
bbox([2,4]) = ceil(max(vertices))';

end
