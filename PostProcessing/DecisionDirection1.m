function [val,sway] = DecisionDirection(mesh,Ie,x,way)

% 갯수
Nf  = length(mesh.hfe);
Ne  = size(Ie,1);
Nd  = length(way);
Cd  = Nd^2;

% 할당
Dec = zeros(Nf,Nd);

% col indexing
hedge2edge = nan(2*Ne,1);
hedge2edge(Ie(:,1)) = 1:Ne;
hedge2edge(Ie(:,2)) = 1:Ne;

for idfi = 1:Nf

    idhes = SearchHfaceLoop(mesh,idfi);
    idhfs = mesh.hef(mesh.het(idhes));
    [idhfs,ii] = sort(idhfs);
    idhes = idhes(ii);

    for j = 1:3

        idfj = idhfs(j);
        idc = hedge2edge(idhes(j));
        
        data = reshape(x(Cd*(idc-1)+1:Cd*idc),Nd,Nd);

        if idfi < idfj
            
            Dec(idfi,:) = Dec(idfi,:) + sum(data);

        else
              
            Dec(idfi,:) = Dec(idfi,:) + sum(data,2)';

        end

    end

end

[val,sway] = max(Dec,[],2);

end