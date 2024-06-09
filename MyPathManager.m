function MyPathManager(foldername)

if nargin
    list = dir(foldername);
else
    list = dir;
    foldername = ".";
end

% string으로 변환
name = string({list.name});

for i = 3:length(name)
  
    % new folder name
    newfn = foldername + "\" + name{i};

    % 폴더이면, 경로를 추가함.
    if isfolder(newfn)

        addpath(newfn);
        MyPathManager(newfn);
        
    end

end

end
