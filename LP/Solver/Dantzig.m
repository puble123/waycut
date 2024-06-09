function [idN,iEntering] = Dantzig(zN,idxN)

[p,~] = min(zN);
i = find(zN==p);
[iEntering,ii] = min(idxN(i));
idN = i(ii);

end  