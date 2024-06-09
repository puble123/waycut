function [Aeq,beq] = GetConstraintsYH(mesh,IE,way)

% 갯수
Ne = size(IE,1);
Nf = length(mesh.hfe);
Nd = length(way);
Cd = Nd^2;

% 미리 할당
r = nan((4*Nf+1)*Cd,1);
c = nan((4*Nf+1)*Cd,1);
v = nan((4*Nf+1)*Cd,1);

% dummy indexing
dummy1 = reshape(ones(Nd,1)*(1:Nd),Cd,1);
dummy2 = (1:Cd)';
dummy3 = reshape(reshape(dummy2,Nd,Nd)',Cd,1);

% col indexing
hedge2edge = nan(2*Ne,1);
hedge2edge(IE(:,1)) = 1:Ne;
hedge2edge(IE(:,2)) = 1:Ne;

s = 0;

for idfi = 1:Nf
   
    idhes = SearchHfaceLoop(mesh,idfi);
    idhfs = mesh.hef(mesh.het(idhes));
    [idhfs,ii] = sort(idhfs);
    idhes = idhes(ii);

    % f1 < f2(항상)
    for jj = 1:2

        idfj1 = idhfs(jj);
        idfj2 = idhfs(jj+1);

        c1 = hedge2edge(idhes(jj));
        c2 = hedge2edge(idhes(jj+1));

        if idfi < idfj1

            r(s+1:s+Cd) = 2*Nd*(idfi-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c1-1) + dummy2;
            v(s+1:s+Cd) = 1;

        else

            r(s+1:s+Cd) = 2*Nd*(idfi-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c1-1) + dummy3;
            v(s+1:s+Cd) = 1;

        end

        s = s+Cd;

        if idfi < idfj2

            r(s+1:s+Cd) = 2*Nd*(idfi-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c2-1) + dummy2;
            v(s+1:s+Cd) = -1;

        else

            r(s+1:s+Cd) = 2*Nd*(idfi-1)+Nd*(jj-1)+dummy1;
            c(s+1:s+Cd) = Cd*(c2-1) + dummy3;
            v(s+1:s+Cd) = -1;

        end
 
        s = s+Cd;

    end

end

row = max(r);

r(s+1:s+Cd) = row+1;
c(s+1:s+Cd) = dummy2;
v(s+1:s+Cd) = 1;

[dummy,i] = sortrows([c,r]);
c = dummy(:,1);
r = dummy(:,2);
v = v(i);

Aeq = sparse(r,c,v);
beq = zeros(row+1,1);
beq(row+1,1) = 1;
beq = sparse(beq);

end

