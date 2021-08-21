function [ g,geq ] = nonlcon(r)

    %Variable
    global yieldStress
    
    % Finite Element Method
    [disp, stress] = finiteElementMethod(r(1,:),r(2,:));


    % Q(2) <= 0.02
    % g(1) = sqrt(Q(2).x^2 + Q(2).y^2)-0.02 <= 0
    g(1) = sqrt(disp(3).^2 + disp(4).^2) - 0.02;    
    
    % abs(stress) <= YieldStress = 250 MPa
    % g(2~11) = abs(stress(1~10)) - yield <= 0
    for i = 1:10
        g(i + 1) = abs(stress(i,:)) - yieldStress;
    end

    geq = [];
    
end