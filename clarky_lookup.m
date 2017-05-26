function [Cl,Cd]= clarky_lookup(Re,alpha)

%alpha_round=round(4*alpha,0)/4;
%50,000 range
alpha_matrix_6=[alpha^6;alpha^5;alpha^4;alpha^3;alpha^2;alpha^1;alpha^0];
alpha_matrix_5=alpha_matrix_6(2:end);
alpha_matrix_4=alpha_matrix_5(2:end);
alpha_matrix_3=alpha_matrix_4(2:end);
alpha_matrix_2=alpha_matrix_3(2:end);
alpha_matrix_1=alpha_matrix_2(2:end);


bottom_alpha_5=-4.25;
upper_alpha_5=11.75;
Cl_5=0;
if(alpha<bottom_alpha_5 | alpha>upper_alpha_5)
    Cl_5=-999;
    Cd_5=-999;
end
if(Cl_5~=-999)
    Cl_5_coeff=[-3.54915*10^-6,7.26083*10^-5,-0.000266724,-0.002352514,0.010829278,0.148561665,0.024413144];
    Cl_5=Cl_5_coeff*alpha_matrix_6;
    Cd_5_coeff=[1.44959*10^-7,-3.0119*10^-6,2.33027*10^-5,-0.000129142,0.000547126,0.001172277,0.030252019];
    Cd_5=Cd_5_coeff*alpha_matrix_6;
end


bottom_alpha_10=-2.5;
upper_alpha_10=15.75;
Cl_10=0;
if(alpha<bottom_alpha_10 | alpha>upper_alpha_10)
    Cl_10=-999;
    Cd_10=-999;
end
if(Cl_10~=-999)
    Cl_10_coeff=[3.86629*10^-7,-1.71622*10^-5,0.000250886,-0.001295471,-0.003548209,0.162965417,0.017283156];
    Cl_10=Cl_10_coeff*alpha_matrix_6;
    Cd_10_coeff=[4.98737*10^-8,-2.03694*10^-6,3.13159*10^-5,-0.000221888,0.000910499,-0.002875081,0.022678308];
    Cd_10=Cd_10_coeff*alpha_matrix_6;
end


bottom_alpha_20=-2.25;
upper_alpha_20=19.75;
Cl_20=0;
if(alpha<bottom_alpha_20 | alpha>upper_alpha_20)
    Cl_20=-999;
    Cd_20=-999;
end
if(Cl_20~=-999)
    Cl_20_coeff=[1.68084*10^-7,-8.46368*10^-6,0.000139933,-0.00087723,-0.000924966,0.131611004,-0.00374539];
    Cl_20=Cl_20_coeff*alpha_matrix_6;
    Cd_20_coeff=[-8.21337*10^-9,4.97235*10^-7,-8.41456*10^-6,3.12697*10^-5,0.000453905,-0.003613174,0.016761914];
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