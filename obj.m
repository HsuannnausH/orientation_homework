function f = obj(r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Variable
    length1 = 9.14;
    length2 = sqrt(length1.^2*2);
    density = 7860;     % 7860 kg * m^-3
    f = 0;
    
    % Element 1~6 
    for i = 1:6
        f = f + density * pi * r(1,:).^2 * length1;
    end
    
    % Element 7~10
    for i = 1:4
        f = f + density * pi * r(2,:).^2 * length2;
    end
end

