%% Constants
%%% Set the material properties of 10-bar truss 
%%% used in functions to "global constant"s

global length E density yieldStress

length = 9.14;          % 9.14 m
E = 200*10.^9;          % 200 GPa
density = 7860;         % 7860 kg * m^-3
yieldStress = 2.5E+08;  % 250 MPa

%% Optimization
% % %     X = fmincon(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) minimizes with
% % %     the default optimization parameters replaced by values in OPTIONS, an
% % %     argument created with the OPTIMOPTIONS function. See OPTIMOPTIONS
% % %     for details. For a list of options accepted by fmincon refer to 
% % %     the documentation.

% Variable setting of the fmicon function
r0=[0.1;0.1];   %癬﹍翴
A=[];           %絬┦ぃ单Α╇兵ン玒计痻皚
b=[];           %絬┦ぃ单Α╇兵ン玒计秖 AX <= b
Aeq=[];         %絬┦ぃ单Α╇兵ン玒计秖
beq=[];         %絬┦单Α╇兵ン玒计秖 AeqX = beq
ub=[0.5;0.5];       %砞璸丁upper bounds
lb=[0.001;0.001];       %砞璸丁lower bounds
options = optimset('display','off','Algorithm','sqp');

[r,fval,exitflag] = fmincon(@(r)obj(r),r0,A,b,Aeq,beq,lb,ub,...
                          @(r)nonlcon(r),options);





