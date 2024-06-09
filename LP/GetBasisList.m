function [idxB] = GetBasisList(mesh,Ie,way,sway)

Nd = length(way);
Nf = length(mesh.hfe);
Ne = size(Ie,1);

for ide = 1:length(Ie)
    
    f1 = mesh.hef(Ie(ide,1));
    f2 = mesh.hef(Ie(ide,2));
    
    p = sway(f1);
    
    if f2 > Nf
        q = 1;
    else
        q = sway(f2);
    end

    idxB(ide) = (Nd^2) * (ide-1) + Nd*(p-1) + q;

end

end