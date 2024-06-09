function [vertices] = MakeVerticesStructuredMesh(rxdata,rydata,gsize)

% 사격형 중심 위치를 계산하고 정점리스트의 크기를 미리 계산.
cxdata = rxdata(1:end-1) + gsize/2; %center of regular box - x
cydata = rydata(1:end-1) + gsize/2; %center of regular box - y

% 정규 그리드 길이
num_rxdata = length(rxdata); %rxdata의 갯수
num_rydata = length(rydata); %rydata의 갯수

% preallocation
num_vertices = 2 * num_rxdata * num_rydata - num_rxdata - num_rydata + 1;
vertices = nan(num_vertices, 2);

% x축 정렬이 되도록 정점리스트를 구성하고 x가 같은 경우 y축 정렬로 순서를
% 기록. 행렬을 정렬할 때 규칙을 따름.
row = 1;
for idx = 1:num_rxdata %x축 정렬.

    vertices(row:row+num_rydata-1, 1) = rxdata(idx);
    vertices(row:row+num_rydata-1, 2) = rydata;
    row = row + num_rydata;

    if idx ~= num_rxdata

        vertices(row:row+num_rydata-2, 1) = cxdata(idx);
        vertices(row:row+num_rydata-2, 2) = cydata;
        row = row + num_rydata-1;

    end

end

end
