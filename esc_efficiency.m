%esc efficiency model
%https://www.researchgate.net/publication/285581158_Development_of_a_dynamic_propulsion_model_for_electric_UAVs
%file:///C:/Users/Adam%20Bell/Documents/University/2017/FYP/Journals/Part%203%20-ESC/green,c_grad_seminar.pdf
%http://www.enu.kz/repository/2010/AIAA-2010-483.pdf
%http://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=2617&context=theses

clear
clc
close all


ESC_max_amps=80;

Ri=0.0035;
PTF=2.1;


V_store=[7.5:0.05:50];
PWS_store=[0:0.005:1];
[a,b]=size(V_store);
[c,d]=size(PWS_store);

efficiency=zeros(d,b);

min_eff=0;


for i=1:b
    for j=1:d
        V=V_store(i);
        PWS=PWS_store(j);
        
        eff=1/V*(V-Ri-PTF*(1-PWS));
        if(eff<min_eff)
            efficiency(j,i)=min_eff;
        else 
            efficiency(j,i)=eff;
        end
        
    end
end

efficiency
contourf(V_store,PWS_store,efficiency)
colorbar('eastoutside')
title('ESC Efficiency');
xlabel('Voltage (V)');
ylabel('PWS (Percent of max power)');