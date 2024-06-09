function [idN,iEntering] =Bland(zN,idxN,tol)


indexs = find(zN < -tol);
[iEntering,iidxNs] = min(idxN(indexs));
idN = indexs(iidxNs);
 
end  