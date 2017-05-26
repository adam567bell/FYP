%larrabee

%this is a demonstation of the larabee method

%as the result is meant to be integrated (but matlab) the solution will be
%solved at a range of intervals along the blade and summed during the
%calculations
%this will be a step across E

clear
clc
close all

J_interest=0.45;
V=18;%m/s
diam=10;%inches
diam_m=diam*25.4/1000;%metres
radius=diam/2%inches
radius_m=diam_m/2;%metres
pitch=8;%inches
pitch_m=pitch*25.4/1000;%metres

%J=0.6%Note: I will need to run this for multiple J values later for plots
eff_store=[];
Ct_store=[];
Cp_store=[];
J_store=0.3:0.001:1

for J=J_store

breaker=0;
    
    
n=V/(J*diam_m);%speed of rotation in revolutions/second
omega=n*2*pi;%speed of rotation in radians/second

lambda=V/(omega*radius_m);%operating constant

B=2;%number of blades

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chord_all=[1,1,1,1,0.9,0.8,0.7,0.6,0.5,0.4,0.3]*diam/10;
chord_dist=[0:0.1:1];
p=polyfit(chord_dist,chord_all,2)


Thrust=4.27%Newtons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
density=1.225;
Tc=2*Thrust/(density*V^2*pi*radius_m^2);



I1_cum=0;
I2_cum=0;
J1_cum=0;
J2_cum=0;

dI1_dE=[];
dI2_dE=[];
dJ1_dE=[];
dJ2_dE=[];

E_all=[0.05:0.1:0.95];
for i=1:length(E_all)
    E=E_all(i);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    c=polyval(p,E)*25.4/1000;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    radius_current=E*radius_m;
    f=(B/2)*sqrt(lambda^2+1)/lambda*(1-radius_current/radius_m);
    F=(2/pi)*acos(exp(-f));
    x=(radius_current/radius_m)/lambda;
    G=F*x^2/(x^2+1);
    phi=atan(V/(omega*radius_current));
    beta=atan((pitch/diam)/(pi*E));
    alpha=beta-phi;
    alpha_deg=alpha*180/pi;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NEEDS WORK FOR SPEED
    blade_speed=sqrt(V^2+(omega*radius_current)^2)
    Re=blade_speed*c/(1.568*10^-5)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    [Cl,Cd]=naca_4412_lookup(Re,alpha_deg);
    %[Cl,Cd]=clarky_lookup(Re,alpha_deg);
    if(Cl==-999)
        breaker=1;
        break;
    end
    D_L=Cd/Cl;
    
    
    dI1_dE(end+1)=4*E*G*(1-D_L/x);
    I1_cum=I1_cum+dI1_dE(end)*(E_all(2)-E_all(1));%check the last bracket
    
    dI2_dE(end+1)=2*E*G*(1-D_L/x)/(x^2+1);
    I2_cum=I2_cum+dI2_dE(end)*(E_all(2)-E_all(1));
    
    dJ1_dE(end+1)=4*E*G*(1+D_L/x);
    J1_cum=J1_cum+dJ1_dE(end)*(E_all(2)-E_all(1));
    
    dJ2_dE(end+1)=2*E*G*(1+D_L/x)*x^2/(x^2+1);
    J2_cum=J2_cum+dJ2_dE(end)*(E_all(2)-E_all(1));
    hello=1;
    
    
%initially define anything which can be defined at the start



end

if(breaker==1)
    eff_store(end+1)=0;
    Ct_store(end+1)=0;
    Cp_store(end+1)=0;
    continue;
end
I1=I1_cum;
I2=I2_cum;
J1=J1_cum;
J2=J2_cum;

zeta=I1/(2*I2)*(1-sqrt(1-4*Tc*I2/I1^2));

dPc_cum=0;
dPc_dE=[]
for i=1:length(E_all)
    dPc_dE(end+1)=dJ1_dE(i)*zeta+dJ2_dE(i)*zeta^2;%check the formula
    dPc_cum=dPc_cum+dPc_dE(end)*(E_all(2)-E_all(1));
end

Pc=dPc_cum;

eff=Tc/Pc
Ct=Tc*J^2*pi/8
Cp=Pc*J^3*pi/8
eff_store(end+1)=eff;
Ct_store(end+1)=Ct;
Cp_store(end+1)=Cp;
if(eff<0 | eff>1)
    break;
end

end
[a,b]=size(eff_store);
figure;
subplot(2,2,1)
plot(J_store(1:b-1),Ct_store(1:b-1))
%plot(J_store(1:b-1),Ct_store(1:b-1)*8./J_store(1:b-1).^2/pi)

title('Ct')
subplot(2,2,2)
plot(J_store(1:b-1),Cp_store(1:b-1))
title('Cp')
subplot(2,2,3)
plot(J_store(1:b-1),eff_store(1:b-1))
title('eta')
subplot(2,2,4)
plot(J_store(1:b-1),eff_store(1:b-1))
title('eta')

% for i=1:length(J_store(1:b-1))
%     if(abs(J_store(i)-J_interest)<=0.0001)
%         Ct_store(i)
%         Cp_store(i)
%         eff_store(i)
%         break;
%     end
% end

