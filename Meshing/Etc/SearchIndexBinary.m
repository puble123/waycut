function [indexs] = SearchIndexBinary(vec,tag)

low = 1;
hig = length(vec);

[indexs] = SearchIndexBinaryRecursive(vec,tag,low,hig);

end