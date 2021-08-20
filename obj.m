function f = obj(r1,r2,length,density)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    f = 0;
    
    % Element 1~6 
    for i = 1:6
        f = f + density * pi * r1.^2 * length;
    end
    
    % Element 7~10
    for i = 1:4
        f = f + density * pi * r2.^2 * length;
    end
end

