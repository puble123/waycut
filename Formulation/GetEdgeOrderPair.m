function [IE] = GetEdgeOrderPair(mesh)

nhe = length(mesh.hef);

IE = zeros(nhe/2,2);
tfe = false(nhe,1);

idIE = 1;

for idhe = 1:length(mesh.hef)

    if tfe(idhe)

        continue;

    end
    
    if idIE > nhe

        return

    end

    idht = mesh.het(idhe);

    % 이미 사용함.
    tfe([idhe,idht]) = true;

    % nan이면 항상 0
    if mesh.hef(idhe) > mesh.hef(idht)

        IE(idIE,:) = [idht,idhe];

    else

        IE(idIE,:) = [idhe,idht];

    end

    idIE = idIE + 1;

end



end

