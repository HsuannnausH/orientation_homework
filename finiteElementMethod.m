function [ disp_node2_x,disp_node2_y,stress,yieldStress ] = finiteElementMethod( r1,r2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %% Variable
    length = 9.14;
    E = 200*10.^9;  % 200 GPa
    density = 7860;     % 7860 kg * m^-3
    yieldStress = 2.5E+08;  % 250 MPa

    %r1 = 0.1;
    %r2 = 0.05;

    %% Create Node Table
    nodeTable = [length*2 length;
                    length*2 0;
                    length*1 length;
                    length*1 0;
                    0 length;
                    0 0];

    %% Create element to node array

    nodeInfo = {[2 6 10],[4 6 9],[1 2 5 8 9],[3 4 5 7 10],[1 7],[3 8]};
    elementToNode = zeros(10,2);
    index = 1;

    for i = 1:10
        for j = 1:6
            for k = 1:size(nodeInfo{j},2)
                if nodeInfo{j}(k) == i
                    elementToNode(i,index) = j;
                    index = index + 1;
                    break
                end 
            end
        end
        index = 1;
    end

    % elementToNode = [3 5;
    %                  1 3;
    %                  4 6;
    %                  2 4;
    %                  3 4;
    %                  1 2;
    %                  4 5;
    %                  3 6;
    %                  2 3;
    %                  1 4]

    %% Create the elementTable using elementToNode
    %%% (10,4) = [A L cos sin]

    elementTable = zeros(10,4);

    for i = 1:10
        % Node of Element
        nodei_x = nodeTable(elementToNode(i,1),1);
        nodei_y = nodeTable(elementToNode(i,1),2);
        nodej_x = nodeTable(elementToNode(i,2),1);
        nodej_y = nodeTable(elementToNode(i,2),2);

        % Area
        if i < 7
            elementTable(i,1) = pi * r1.^2;
        else
            elementTable(i,1) = pi * r2.^2;
        end

        % Length of element
        elementTable(i,2) = sqrt(power(nodej_x - nodei_x ,2)+power(nodej_y - nodei_y ,2));

        % cos
        elementTable(i,3) = (nodej_x - nodei_x)/elementTable(i,2);

        % sin
        elementTable(i,4) = (nodej_y - nodei_y)/elementTable(i,2);
    end


    %% Stiffness Matrix


    stiffnessMatrix = zeros(12,12);
    globalDOF = zeros(1,4);
    tmpMatrix = cell(6,2);

    for i = 1:10
        globalDOF(1,1) = elementToNode(i,1) * 2 -1;
        globalDOF(1,2) = elementToNode(i,1) * 2;
        globalDOF(1,3) = elementToNode(i,2) * 2 -1;
        globalDOF(1,4) = elementToNode(i,2) * 2;

        cos = elementTable(i,3);
        sin = elementTable(i,4);

        tmpMatrix{1,1} = cos.^2;  
        tmpMatrix{2,1} = sin.^2;
        tmpMatrix{3,1} = -cos.^2; 
        tmpMatrix{4,1} = -sin.^2;  
        tmpMatrix{5,1} = sin*cos;   
        tmpMatrix{6,1} = -sin*cos;

        tmpMatrix{1,2} = [globalDOF(1) globalDOF(1);
                          globalDOF(3) globalDOF(3)];   % cos2
        tmpMatrix{2,2} = [globalDOF(2) globalDOF(2);    
                          globalDOF(4) globalDOF(4)];   % sin2
        tmpMatrix{3,2} = [globalDOF(3) globalDOF(1);
                          globalDOF(1) globalDOF(3)];   % -cos2
        tmpMatrix{4,2} = [globalDOF(4) globalDOF(2);
                          globalDOF(2) globalDOF(4)];   % -sin2
        tmpMatrix{5,2} = [globalDOF(2) globalDOF(1);
                          globalDOF(1) globalDOF(2);
                          globalDOF(4) globalDOF(3);
                          globalDOF(3) globalDOF(4)];  % cos*sin
        tmpMatrix{6,2} = [globalDOF(4) globalDOF(1);
                          globalDOF(1) globalDOF(4);
                          globalDOF(2) globalDOF(3);
                          globalDOF(3) globalDOF(2)];  % cos*sin

        for j = 1:6
            for k = 1:size(tmpMatrix{j,2},1)
                stiffnessMatrix(tmpMatrix{j,2}(k,1),tmpMatrix{j,2}(k,2)) =...
                    stiffnessMatrix(tmpMatrix{j,2}(k,1),tmpMatrix{j,2}(k,2)) + ...
                    E*elementTable(i,1)*tmpMatrix{j,1}/elementTable(i,2);
            end
        end
    end

    %% Displacement

    force = zeros(8,1);
    force(4) = -1E+07;  % 1.0 x 10^7 N
    force(8) = -1E+07;

    % Duplicate the 1~8rows&column of stiffnessMatrix
    stiffness_disp = zeros(8);  
    for i = 1:8
        for j = 1:8
            stiffness_disp(i,j) = stiffnessMatrix(i,j);
        end
    end

    % stiffness * disp = force
    disp = inv(stiffness_disp) * force;
    disp_node2_x = disp(3);
    disp_node2_y = disp(4);

    %% Stress
    stress = zeros(10,1);
    trans = zeros(1,4);
    disp_element = zeros(4,1);
    for i = 9:12
        disp(i,1) = 0;
    end

    for i = 1:10
        cos = elementTable(i,3);
        sin = elementTable(i,4);

        trans(1,1) = -cos;
        trans(1,2) = -sin;
        trans(1,3) = cos;
        trans(1,4) = sin;

        disp_element(1,1) = disp(elementToNode(i,1) * 2 -1,1);
        disp_element(2,1) = disp(elementToNode(i,1) * 2,1);
        disp_element(3,1) = disp(elementToNode(i,2) * 2 -1,1);
        disp_element(4,1) = disp(elementToNode(i,2) * 2,1);

        stress(i) = E*(trans*disp_element)/elementTable(i,2);

    end

    %% Reaction Force

    % Duplicate the 9~12rows&column of stiffnessMatrix
    stiffness_reac = zeros(4,12);
    for i = 1:4
        for j = 1:12
            stiffness_reac(i,j) = stiffnessMatrix(i+8,j);
        end
    end

    % R = K * Q
    reactionForce = stiffness_reac * disp;


end

