function [x] = ConvertDir2Solution(mesh,Ie,sway,way)

Nd = length(way);
Ne = size(Ie,1);
Nf = length(mesh.hfe);

x = zeros(Nd^2 * Ne,1);

for ide = 1:Ne

    % 정렬되어 있음
    f1 = mesh.hef(Ie(ide,1));
    f2 = mesh.hef(Ie(ide,2));

    p = sway(f1);
    
    if f2 > Nf

        q = 1;

    else

        q = sway(f2);

    end

    index = Nd^2 * (ide-1) + Nd * (p-1) + q;
    
    x(index) = 1;

end

end


