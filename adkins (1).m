function [eta]=adkins(pitch,diam,J,target_speed,thrust,chord,naca4412_50000,naca4412_100000,naca4412_200000)

%currently I'm also defining J which I kind of want to be a free var!
%could I run multiple J's and select the max efficiency one
%but how do I guarantee that it can generate the thrust??
%it magically makes it get the thrust at any rotation speed!!!

%%%%%naca4412_100000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_100000.xlsx');



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

Tc=thrust*2/(density*V^2*pi*radius_m^2);
BigC=0.0;
BigC_error=1
while(BigC_error>0.002)


    I1_total=0;
    I2_total=0;
    J1_total=0;
    J2_total=0;
    x_all=0.05:0.1:0.95;

    for i=1:length(x_all)
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
        cl_error=1;


        %%%%%%%%%%%%%%%%
        Cl=0.6;
        %%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%
        Cd=0.02;
        %%%%%%%%%%%%%%%
        count=0;
        break_loop=0;
        while(cl_error>0.01)

            Wc=4*pi*lambda*G*V*radius_m*x/(Cl*B);
            c=chord(i);
            c_m=c*25.4/1000;
            sigma=B*c_m/(pi*radius_current);
            Cy=Cl*cos(phi)-Cd*sin(phi);

            K=Cy/(4*sin(phi)*sin(phi));
            a=sigma*K*(F-sigma*K);
            W=V*(1+a)/sin(phi);

            Re=1.225*W*c_m/(1.846*10^-5);

            e=Cd/Cl;

            Beta=atan(p_D/(pi*x));
            alpha=Beta-phi;
            alpha_deg=alpha*(180/pi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
            
            




%%%%%%%%%%%%%%%%%%%%%
            
            
            
            [Cl_new,Cd_new]=Cl_lookup(alpha_deg,Re,naca4412_50000,naca4412_100000,naca4412_200000);
            if(Cl_new==-999)
                break_loop=1;
                eta=0;
                return;
                break;
            end
            cl_error=abs((Cl_new-Cl)/Cl);
            Cl=Cl_new;
            Cd=Cd_new;
            count=count+1
            if(count>=100)
                break_loop=1;
                eta=0;
                return;
                break;
            end
        end
        if(break_loop==1)
            eta=0;
            return;
            break;
        end
        I1=4*x*G*(1-e*tan_phi)
        I1_total=I1_total+I1;
        I2=lambda*(I1/(2*x))*(1+e/tan_phi)*sin(phi)*cos(phi)
        I2_total=I2_total+I2;
        J1=4*x*G*(1+e/tan_phi)
        J1_total=J1_total+J1;
        J2=(J1/2)*(1-e*tan_phi)*cos(phi)*cos(phi)
        J2_total=J2_total+J2;
    end

    %     x
    %     radius_current
    %     lambda
    %     tan_phi_t
    %     phi_t
    %     tan_phi
    %     phi
    %     f
    %     F
    %     G
    %     Cl
    %     Cd
    %     Wc
    %     W
    %     Re
    %     e
    %     Beta
    %     alpha
    %     Cy
    %     %Cx
    %     K
    %     c
    %     sigma
    %     a
    %     BigC
    BigC_new=(I1_total/(2*I2_total))-sqrt((I1_total/(2*I2_total))^2-Tc/I2_total)
    BigC_error=(BigC_new-BigC)/BigC;
    BigC=BigC_new;
    Pc=J1_total*BigC+J2_total*BigC^2;
    eta=Tc/Pc
    hello=17;
    if(break_loop==1)
        eta=0;
    end
end

    
    
    
    
end

