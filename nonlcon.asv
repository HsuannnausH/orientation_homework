function [ g,geq ] = nonlcon(r)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    % Finite Element Method
    [disp_node2_x,disp_node2_y,stress,yieldStress] = finiteElementMethod(r(1,:),r(2,:));


    % Q(2) <= 0.02
    % g(1) = sqrt(Q(2).x^2 + Q(2).y^2)-0.02 <= 0
    g(1) = sqrt(disp_node2_x.^2 + disp_node2_y.^2) - 0.02;    
    
    % abs(stress) <= YieldStress = 250 MPa
    % g(2~11) = abs(stress(1~10)) - yield <= 0
    for i = 1:10
        g(i + 1) = abs(stress(i,:)) - yieldStress;
    end

    geq = [];
end