function [Ct,Cp,eta]=mcVortex(pitch,diam,J,target_speed,t_max,chord,naca4412_50000,naca4412_100000,naca4412_200000)


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

Vt=n_radps*radius_m;

x_all=0.05:0.1:0.95;
Ct=0;
Cp=0;
for i=1:length(x_all)
    x=x_all(i);
    radius_current=radius_m*x;
    lambda=V/(n_radps*radius_m);
    phi_t=atan(lambda);
    f=(B/2)*(1-x)/sin(phi_t);
    F=(2/pi)*acos(exp(-f));
    phi=atan(lambda/x);
    beta=atan(p_D/(pi*x));
    c=chord(i);
    c_m=c*25.4/1000;
    sigma=B*c_m/(pi*radius_m);
    wt_Vt=0.005;%consider starting at 0, but the results go weird??
    error_wt_Vt=1;
    count=0;
    skip=0;
    while(abs(error_wt_Vt)>0.005)
        count=count+1;
        wa_Vt=0.5*(-lambda+sqrt(lambda^2+4*wt_Vt*(x-wt_Vt)));
        t_max_current=t_max(i);
        del_alpha=4*lambda*sigma*t_max_current/(15*(lambda^2+sigma^2)*c_m);
        wt=wt_Vt*Vt;
        wa=wa_Vt*Vt;
        del_theta=atan((V+wa)/(n_radps*radius_current-2*wt))-atan((V+wa)/(n_radps*radius_current));
        a=0.1333333;
        del_Cl=del_theta*a/4;
        alpha_i=atan((V+wa)/(n_radps*radius_current-wt))-phi;
        alpha=beta-alpha_i-phi-del_alpha;
        alpha_deg=alpha*180/pi;
        Ve_Vt=sqrt((lambda+wa/Vt)^2+(x-wt/Vt)^2);
        
        Re=Ve_Vt*Vt*c_m/(15.11*10^-6);

        [Cl_new,Cd_new]=Cl_lookup(alpha_deg,Re,naca4412_50000,naca4412_100000,naca4412_200000);
        if(Cl_new==-999 | Cd_new==-999)
            skip=1;
            break;
        end
        Cl=Cl_new-del_Cl;
        Cd=Cd_new;


        
        circ=0.5*c_m*Cl*(Ve_Vt*Vt);
        wt_new=B*circ/(4*pi*radius_current*F);
        wt_Vt_new=wt_new/Vt;
        wt_Vt_update=wt_Vt_new/2+wt_Vt/2;

        error_wt_Vt=(wt_Vt_update-wt_Vt)/wt_Vt;
        wt_Vt=wt_Vt_update;
        if(count>99)
            skip=1;
            break;
        end
    
    end
    if(skip==0)
        Ct=Ct+pi/8*((J^2+pi^2*x^2)*sigma*(Cl*cos(phi+alpha_i)-Cd*sin(phi+alpha_i))*(x_all(2)-x_all(1))); %replace alpha_i with alpha for the old more accurate version
        Cp=Cp+pi/8*(pi*x*(J^2+pi^2*x^2)*sigma*(Cl*sin(phi+alpha_i)+Cd*cos(phi+alpha_i))*(x_all(2)-x_all(1)));
        
        %Ct=Ct+pi/8*((J^2+pi^2*x^2)*sigma*(Cl*cos(phi+alpha)-Cd*sin(phi+alpha))*(x_all(2)-x_all(1))); %replace alpha_i with alpha for the old more accurate version
        %Cp=Cp+pi/8*(pi*x*(J^2+pi^2*x^2)*sigma*(Cl*sin(phi+alpha)+Cd*cos(phi+alpha))*(x_all(2)-x_all(1)));
    end
    
    
end

%this is to make it all line up with the uiuc data
%however I think the second blade is already considered
Ct=2*Ct;
Cp=2*Cp;

if(Cp~=0)
    eta=Ct*J/Cp;
else
    eta=0;
end
    


















end