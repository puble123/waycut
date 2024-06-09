function [Aeq,beq] = GetConstraintsTJ(mesh,Ie,way)

% 갯수
Ne = size(Ie,1);
Nf = length(mesh.hfe);
Nd = length(way);
Cd = Nd^2;

% 미리 할당
r = nan((4*Nf+Ne)*Cd,1);
c = nan((4*Nf+Ne)*Cd,1);
v = nan(4*Cd*Nf+Cd*Ne,1);

% dummy indexing
dummy1 = reshape(ones(Nd,1)*(1:Nd),Cd,1);
dummy2 = (1:Cd)';
dummy3 = reshape(reshape(dummy2,Nd,Nd)',Cd,1);

% col indexing
hedge2edge = nan(2*Ne,1);
hedge2edge(Ie(:,1)) = 1:Ne;
hedge2edge(Ie(:,2)) = 1:Ne;

s = 0;

% 독립행들만 만들기 위해.
delrow = [];

for idf = 1:Nf
   
    idhes = SearchHfaceLoop(mesh,idf);
    idhfs = mesh.hef(mesh.het(idhes));
    [idhfs,ii] = sort(idhfs);
    idhes = idhes(ii);

    % f1 < f2(항상)
    for jj = 1:2

        f1 = idhfs(jj);
        f2 = idhfs(jj+1);

        c1 = hedge2edge(idhes(jj));
        c2 = hedge2edge(idhes(jj+1));

        if idf < f1

            r(s+1:s+Cd) = 2*Nd*(idf-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c1-1) + dummy2;
            v(s+1:s+Cd) = 1;
            
        else

            r(s+1:s+Cd) = 2*Nd*(idf-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c1-1) + dummy3;
            v(s+1:s+Cd) = 1;


        end

        s = s+Cd;

        if idf < f2

            r(s+1:s+Cd) = 2*Nd*(idf-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c2-1) + dummy2;
            v(s+1:s+Cd) = -1;

        else

            r(s+1:s+Cd) = 2*Nd*(idf-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c2-1) + dummy3;
            v(s+1:s+Cd) = -1;

        end
        
        s = s+Cd;

    end

end



% 완화조건에 대한 제한식추가.
row = max(r);

for ide = 1:Ne

    r(s+1:s+Cd) = row+ide;
    c(s+1:s+Cd) = Cd*(ide-1) + dummy2;
    v(s+1:s+Cd) = 1;

    s = s+Cd;

end

[dummy,i] = sortrows([c,r]);
c = dummy(:,1);
r = dummy(:,2);
v = v(i);

Aeq = sparse(r,c,v);
beq = zeros(row+ide,1);
beq(row+1:row+ide,1) = 1;

end

