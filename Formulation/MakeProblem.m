function [f,Aeq,beq] = MakeProblem(mesh,Ie,way,method)

% 옵션에 따른 문제 설정
if method == "Kimtj" % 김태정교수님

    [f] = GetCostFunctionKimtj(mesh,Ie,way);
    [Aeq,beq] = GetConstraintsKimtj(mesh,Ie,way);

elseif method == "Kimyh" % 김영한석사님
    
    [f] = GetCostFunctionKimtj(mesh,Ie,way);
    [Aeq,beq] = GetConstraintsKimyh(mesh,Ie,way);

elseif method == 2 % Time


end





end
