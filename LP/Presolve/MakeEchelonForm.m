function [A,b,idxB,infeasible] = MakeEchelonForm(A,b,idxB)

% sparse matrix일 때
[r,c,v] = find(A);

% tol
tol = max(max(r),max(c)) * eps * norm(A,"inf");

% 불가능한 식
infeasible = false;

% R is CSR and C is CSC 
[R,C] = MakeSparse(r,c,v);

% matlab의 sparse matrix 구조는 CSC를 따름
rmax = length(R.cols);
cmax = length(C.rows);

% 컬럼 인덱스
cols = (1:cmax)';
if nargin == 3
    cols(idxB) = [];
    cols = [idxB(:);cols];
end

% 피벗을 진행한 행에 대해서
tfrow = true(rmax,1);

% idxB: Basis index(여기선 독립열)
idxB = [];

for idc = 1:cmax

    % Pivot Col
    pcol = cols(idc);

    % Pivot Col에 속한 행 리스트
    arows = C.rows{pcol};

    % Pivot을 하지 않은 남은 행들 리스트
    indx = find(tfrow(arows));
    arows = arows(indx);

    % 만약 비었다면 넘어감
    if isempty(arows)
        continue;
    end

    % 피벗행
    [val,iid] = max(abs(C.vals{pcol}(indx)));

    % tol보다 작은 경우 0으로 취급
    if val < tol
        C.rows{pcol}(indx) = [];
        C.vals{pcol}(indx) = [];
        for a = 1:length(arows)
            jndx = SearchSameIndex(R.cols{arows(a)},pcol);
            R.cols{arows(a)}(jndx) = [];
            R.vals{arows(a)}(jndx) = [];
        end
    end
    
    %Pivot 시작
    prow = arows(iid);
    arows(iid) = [];
    
    % Pivot Row에 해당하는 열 찾기
    tfp = (R.cols{prow} == pcol);
    idpcol = find(tfp);
    idpcols= find(~tfp);

    % 단위행으로 만들기
    b(prow) = b(prow)/R.vals{prow}(idpcol);
    R.vals{prow}(:) = R.vals{prow}(:)/R.vals{prow}(idpcol);
    for i = 1:length(R.cols{prow})
        col = R.cols{prow}(i);
        jndx = SearchSameIndex(C.rows{col},prow);
        C.vals{col}(jndx) = R.vals{prow}(i); 
    end

    % 추가/제거할 행/열
    delr = []; delc = [];
    addr = []; addc = []; addv = [];
   
    % 피봇팅
    for p = 1:length(arows)

        % 행
        arow = arows(p);
        
        % 피벗 열
        tfa = (R.cols{arow} == pcol);

        % 열 분리
        idacol = find(tfa);
        idacols= find(~tfa);

        % 계수
        coef = R.vals{arow}(idacol);
        
        % 삭제할 행/열에 추가
        delr = [delr; arow]; 
        delc = [delc; R.cols{arow}(idacol)];
        
        % b 업데이트
        b(arow) = b(arow) - coef * b(prow);

        % 열
        cols1 = R.cols{prow}(idpcols);
        cols2 = R.cols{arow}(idacols);

        % for문
        for k1 = 1:length(idpcols)
            
            % idpcols과 idacols가 같은 경우
            k2 = find(cols2==cols1(k1),1);

            % 같은 열이 없으면 arow행에 추가해야함.
            if isempty(k2)
                
                addr = [addr; arow];
                addc = [addc; R.cols{prow}(idpcols(k1))];
                addv = [addv; -coef * R.vals{prow}(idpcols(k1))];

            else
                
                % 같은 열이 있으면 수정해야함.
                R.vals{arow}(idacols(k2)) = R.vals{arow}(idacols(k2)) ...
                    - coef * R.vals{prow}(idpcols(k1));

                % col
                col = R.cols{arow}(idacols(k2));
                jndx = SearchSameIndex(C.rows{col},arow);
                
                % CSC도 수정해야함.
                C.vals{col}(jndx) = R.vals{arow}(idacols(k2)); 
    
                if abs(R.vals{arow}(idacols(k2))) < 1e-10

                    delr = [delr; arow];
                    delc = [delc; R.cols{arow}(idacols(k2))];

                end

            end

        end

    end

    % 추가
    for a = 1:length(addr)

        indx = SearchInsertIndex(R.cols{addr(a)},addc(a));
        jndx = SearchInsertIndex(C.rows{addc(a)},addr(a));

        R.cols{addr(a)} = [R.cols{addr(a)}(1:indx-1); addc(a); R.cols{addr(a)}(indx:end)];
        R.vals{addr(a)} = [R.vals{addr(a)}(1:indx-1); addv(a); R.vals{addr(a)}(indx:end)];

        C.rows{addc(a)} = [C.rows{addc(a)}(1:jndx-1); addr(a); C.rows{addc(a)}(jndx:end)];
        C.vals{addc(a)} = [C.vals{addc(a)}(1:jndx-1); addv(a); C.vals{addc(a)}(jndx:end)];

    end

    % 제거
    for d = 1:length(delr)
        
        indx = SearchSameIndex(R.cols{delr(d)},delc(d));
        jndx = SearchSameIndex(C.rows{delc(d)},delr(d));

        R.cols{delr(d)}(indx) = [];
        R.vals{delr(d)}(indx) = [];

        C.rows{delc(d)}(jndx) = [];
        C.vals{delc(d)}(jndx) = [];

    end

    % 피벗을 수행하고 독립열에 추가함.
    tfrow(prow) = false;
    idxB = [idxB; pcol];

end

[r,c,v] = ConvertCSC2Index(C);

rr = unique(r);
delr = setdiff((1:rmax),rr);

A(delr,:) = [];
b(delr,:) = [];



end