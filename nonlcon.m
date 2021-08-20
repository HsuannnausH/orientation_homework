function [ g,geq ] = nonlcon( disp_node2,stress,yeildStress )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    % Q(2) <= 0.02
    % g(1) = Q(2)-0.02 <= 0
    g(1) = disp_node2 - 0.02    
    
    % abs(stress) <= YieldStress = 250 MPa
    % 

    geq = [];
end

