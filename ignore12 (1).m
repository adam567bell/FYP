
clear
clc
target_speed=15;
diam=15;
pitch=9;
J=0.504745;
BigC=0.109663;
B=2;
thrust=1.4*9.81;
chord=[1,1,1,1,1,1];

diam=diam;
diam_m=diam*25.4/1000;
radius=diam/2;
radius_m=diam_m/2;
p_D=pitch/diam;

V=target_speed;

n_rps=V/(J*diam_m);%J=V/(nD)
n_radps=n_rps*2*pi;
B=2;
density=1.225;

Tc=thrust*2/(density*V^2*pi*radius_m);
BigC=0.109663;

x_all=0.05:0.1:0.95;
for i=1:1%length(x_all)
    x=x_all(i);
    radius_current=radius_m*x;
    lambda=V/(n_radps*radius_m);
    tan_phi_t=lambda*(1+BigC/2);
    phi_t=atan(tan_phi_t);
    tan_phi=tan_phi_t/x;
    phi=atan(tan_phi);
    f=(B/2)*(1-x)/sin(phi_t);
    F=(2/pi)*acos(exp(-f));
    G=F*cos(phi)*sin(phi);
    %%%%%%%%%%%%%%%%
    Cl=-0.0158;
    %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%
    Cd=0.03295;
    %%%%%%%%%%%%%%%
    Wc=4*pi*lambda*G*V*radius_m*x/(Cl*B);
    c=chord(i);
    c_m=c*25.4/1000;
    sigma=B*c_m/(2*pi*radius_current);
    Cy=Cl*cos(phi)-Cd*sin(phi);
    
    K=Cy/(4*sin(phi)*sin(phi));
    a=sigma*K*(F-sigma*K);
    W=V*(1+a)/sin(phi);
    
    Re=1.225*W*c/(1.846*10^-5);
    
    e=Cd/Cl;
    
    Beta=atan(p_D/(pi*x));
    alpha=Beta-phi;
    alpha_deg=alpha*(180/pi);
    I1=4*x*G*(1-e*tan_phi);
    I2=lambda*(I1/(2*x))*(1+e/tan_phi)*sin(phi)*cos(phi);
    J1=4*x*G*(1+e/tan_phi);
    J2=(J1/2)*(1-e*tan_phi)*cos(phi)*cos(phi);
    
    
    
    
    
    
end