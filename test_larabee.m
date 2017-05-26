%larrabee

%this is a demonstation of the larabee method

%as the result is meant to be integrated (but matlab) the solution will be
%solved at a range of intervals along the blade and summed during the
%calculations
%this will be a step across E



V=15;%m/s
diam=10;%inches
diam_m=diam*25.4/1000;%metres
radius=diam/2%inches
radius_m=diam_m/2;%metres
pitch=8;%inches
pitch_m=pitch*25.4/1000;%metres

J=0.6%Note: I will need to run this for multiple J values later for plots

n=V/(J*diam_m);%speed of rotation in revolutions/second
omega=n*2*pi;%speed of rotation in radians/second

lambda=V/(omega*radius_m);%operating constant

B=2;%number of blades

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chord_all=[1,1,1,1,1,1,1,1,1,1]
Thrust=0.8%Newtons
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
    c=chord_all(i)
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
    D_L=Cd/Cl;
    
    
    dI1_dE(end+1)=4*E*G*(1-D_L/x);
    I1_cum=I1_cum+dI1_dE(end)*(E_all(2)-E_all(1));%check the last bracket
    
    dI2_dE(end+1)=2*E*G*(1-D_L/x)/(x^2+1);
    I2_cum=I2_cum+dI2_dE(end)*(E_all(2)-E_all(1));
    
    dJ1_dE(end+1)=4*E*G*(1+D_L/x);
    J1_cum=J1_cum+dJ1_dE(end)*(E_all(2)-E_all(1));
    
    dJ2_dE(end+1)=2*E*G*(1+D_L/x)*x^2/(x^2+1);
    J2_cum=J2_cum+dJ2_dE(end)*(E_all(2)-E_all(1));
    
    
    
%initially define anything which can be defined at the start



end


I1=I1_cum;
I2=I2_cum;
J1=J1_cum;
J2=J2_cum;

zeta=I1/(2*I2)*(1-sqrt(1-4*Tc*I2/I1^2));

dPc_cum=0;
dPc_dE=[]
for i=1:length(E_all)
    dPc_dE(end+1)=dJ1_dE(i)*zeta+dJ2_dE(i)*zeta^2%check the formula
    dPc_cum=dPc_cum+dPc_dE(end)*(E_all(2)-E_all(1));
end

Pc=dPc_cum;

eff=Tc/Pc


