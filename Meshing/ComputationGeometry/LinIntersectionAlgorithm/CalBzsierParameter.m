function [t,u] = CalBzsierParameter(sa,ea,sb,eb,tol)

bottom = (sa(1)-ea(1)) * (sb(2)-eb(2)) - (sa(2)-ea(2)) * (sb(1)-eb(1));

if abs(bottom) < tol

    t = nan;
    u = nan;
    return

end

up_t   = (sa(1)-sb(1)) * (sb(2)-eb(2)) - (sa(2)-sb(2)) * (sb(1)-eb(1));
up_u   = (sa(1)-sb(1)) * (sa(2)-ea(2)) - (sa(2)-sb(2)) * (sa(1)-ea(1));

t = up_t/bottom;
u = up_u/bottom;

end