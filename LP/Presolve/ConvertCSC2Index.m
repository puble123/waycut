function [r,c,v] = ConvertCSC2Index(C)

r = [];
c = []; 
v = [];

for idc = 1:length(C.rows)

    Nc = length(C.rows{idc});

    r  = [r; C.rows{idc}];
    c  = [c; idc*ones(Nc,1)];
    v  = [v; C.vals{idc}];

end

end
