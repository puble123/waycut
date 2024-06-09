function [idfs] = BoxIndex2FaceIndex(i,j,jmax)

% 박스를 구성하는 메시 색인을 반환
% jmax는 Box를 Y축으로 쌓았을 때 Y축으로 가장 높이 쌓을 수 있는 갯수
idbox = jmax*(i-1)+j;      % 박스 인덱스
idfs = nan(4*length(i),1); % face 번호로 변환

% 박스를 구성하는 메시는 총 4개이고 색인은 4*(box-1) + 1 ~ 4 이다.
idfs(1:4:end) = 4*(idbox-1)+1;
idfs(2:4:end) = 4*(idbox-1)+2;
idfs(3:4:end) = 4*(idbox-1)+3;
idfs(4:4:end) = 4*(idbox-1)+4;

end