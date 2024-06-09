function [cf] = GetOrientation(pa,pb,pc)

val = (pb(2) - pa(2)) * (pc(1) - pb(1)) - (pb(1) - pa(1)) * (pc(2) - pb(2));

if (val == 0)

    cf = 0; % collinear

elseif (val > 0)

    cf = -1; % clockwise

else

    cf = +1; % counterclockwise

end

end