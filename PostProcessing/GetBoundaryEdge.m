function [bedge] = GetBoundaryEdge(mesh,sway)

Nhe = length(mesh.hen);
Nf = length(mesh.hfe);

tff = true(Nf,1);
tfe = true(Nhe,1);

qf = 1;

bedge = cell(1,1);
q = 1;
bedge{q} = [];

while ~isempty(qf)

    % hedge
    idhes = SearchHfaceLoop(mesh,qf(1));
    idfe  = mesh.hef(idhes(1));

    for id = 1:length(idhes)

        % haf edge
        idhe = idhes(id);
        idft = mesh.hef(mesh.het(idhe));


        % boundary
        if idft > Nf
            
            % 외곽인 경우 항상 추가
            bedge{q}(end+1,1) = idhe;

        else

            % 두 face의 방향이 다르면 추가
            if sway(idfe) ~= sway(idft)
                
                if tfe(idhe)
                    bedge{q}(end+1,1) = idhe;
                end
                tfe(idhe) = false;
            
            else
                
                % 방향이 같으면 큐에 추가
                if tff(idft)

                    qf = [qf; idft];
                    tff(idft) = false;
                    
                end

            end
        end

    end

    % idfe는 수행했음
    tff(idfe) = false;
    qf(1) = [];

    % 큐가 비어있으면 tff에서 찾음
    if isempty(qf)

        q = q+1;
        qf = find(tff,1);
        
        if ~isempty(qf)
            bedge{q} = [];
        end

    end

end


end