function [R,C] = MakeSparse(r,c,v)

rmax = max(r);
cmax = max(c);

%CSR/CSC
[dummy1,index] = sortrows([r,c]);
[dummy2,jndex] = sortrows([c,r]);

% 저장할 행/열 정보
R.cols = cell(rmax,1);
R.vals = cell(rmax,1);
C.rows = cell(cmax,1);
C.vals = cell(cmax,1);

Nd = length(r);

sr = 1;
er = 1;

while er <= Nd

    if er == Nd || dummy1(er,1) ~= dummy1(er+1,1)

        R.cols{dummy1(sr,1)} = dummy1(sr:er,2);
        R.vals{dummy1(sr,1)} = v(index(sr:er));

        sr = er+1;
        er = er+1;

    else

        er = er+1;
        
    end

end

sc = 1;
ec = 1;

while ec <= Nd

    if ec == Nd || dummy2(ec,1) ~= dummy2(ec+1,1)

        C.rows{dummy2(sc,1)} = dummy2(sc:ec,2);
        C.vals{dummy2(sc,1)} = v(jndex(sc:ec));

        sc = ec+1;
        ec = ec+1;

    else

        ec = ec+1;

    end

end