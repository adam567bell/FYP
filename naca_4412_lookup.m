function [Cl,Cd]= naca_4412_lookup(Re,alpha)

%alpha_round=round(4*alpha,0)/4;
%50,000 range
alpha_matrix_6=[alpha^6;alpha^5;alpha^4;alpha^3;alpha^2;alpha^1;alpha^0];
alpha_matrix_5=alpha_matrix_6(2:end);
alpha_matrix_4=alpha_matrix_5(2:end);
alpha_matrix_3=alpha_matrix_4(2:end);
alpha_matrix_2=alpha_matrix_3(2:end);
alpha_matrix_1=alpha_matrix_2(2:end);


bottom_alpha_5=-4.75;
upper_alpha_5=8.75;
Cl_5=0;
if(alpha<bottom_alpha_5 | alpha>upper_alpha_5)
    Cl_5=-999;
    Cd_5=-999;
end
if(Cl_5~=-999)
    Cl_5_coeff=[2.56824987386*10^-6,6.92652620269*10^-5,-1.50114981326*10^-3,1.04042249664*10^-3,1.43222368167*10^-1,2.64191719890*10^-2];
    Cl_5=Cl_5_coeff*alpha_matrix_5;
    Cd_5_coeff=[-9.558514900*10^-8,4.102585398*10^-7,1.671959520*10^-5,-1.786245140*10^-4,9.830299360*10^-4,7.367339324*10^-4,3.231281619*10^-2];
    Cd_5=Cd_5_coeff*alpha_matrix_6;
end


bottom_alpha_10=-5.25;
upper_alpha_10=9;
Cl_10=0;
if(alpha<bottom_alpha_10 | alpha>upper_alpha_10)
    Cl_10=-999;
    Cd_10=-999;
end
if(Cl_10~=-999)
    Cl_10_coeff=[-0.003655578,0.134728478,0.425918918];
    Cl_10=Cl_10_coeff*alpha_matrix_2;
    Cd_10_coeff=[3.230379373*10^-6,-4.877857738*10^-5,3.029531237*10^-4,-2.883421465*10^-4,1.836771347*10^-2];
    Cd_10=Cd_10_coeff*alpha_matrix_4;
end


bottom_alpha_20=-3.75;
upper_alpha_20=12;
Cl_20=0;
if(alpha<bottom_alpha_20 | alpha>upper_alpha_20)
    Cl_20=-999;
    Cd_20=-999;
end
if(Cl_20~=-999)
    Cl_20_coeff=[-0.001975022,0.130979159,-0.004609107];
    Cl_20=Cl_20_coeff*alpha_matrix_2;
    Cd_20_coeff=[9.51889484*10^-9,-6.22430335*10^-7,1.54285652*10^-5,-1.65372140*10^-4,8.63445867*10^-4,-2.41333366*10^-3,1.48672723*10^-2];
    Cd_20=Cd_20_coeff*alpha_matrix_6;
end

if(Re<=50000 & Cl_5~=-999)
    Cl=Cl_5;
    Cd=Cd_5;
elseif (Re>50000 & Re<=100000 & Cl_5~=-999 & Cl_10~=-999)
    propotion_lower=1-(Re-50000)/50000;
    Cl=propotion_lower*Cl_5+(1-propotion_lower)*Cl_10;
    Cd=propotion_lower*Cd_5+(1-propotion_lower)*Cd_10;
elseif(Re>100000 & Re<=200000 & Cl_10~=-999 & Cl_20~=-999)
    propotion_lower=1-(Re-100000)/100000;
    Cl=propotion_lower*Cl_10+(1-propotion_lower)*Cl_20;
    Cd=propotion_lower*Cd_10+(1-propotion_lower)*Cd_20;
elseif(Re>200000 & Cl_20~=-999)
    Cl=Cl_20;
    Cd=Cd_20;
else
    Cl=-999;
    Cd=-999;
end        


end