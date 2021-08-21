function f = obj(r)

    % Constants
    global length density
    
    f = 0;
    
    % Element 1~6 
    for i = 1:6
        f = f + density * pi * r(1,:).^2 * length;
    end
    
    % Element 7~10
    for i = 1:4
        f = f + density * pi * r(2,:).^2 * sqrt(length.^2*2);
    end
    
end

