
clear
clc
%close all

cell_count=8;

Kv=320;%RPM/V
Rm=0.020;%Ohms
Io=1.5;%A
Io_voltage=8.4;%V
Motor_max_power=1900;%W

cruise_thrust=13;%Newtons
ROC=4;%Rate of Climb in m/s
V=22;%m/s
store=zeros(999,16);
mass=10;%kg

gravity=9.81;%yep
ROC_speed=V;%assume rate of climb at the cruise speed
ROC_drag=cruise_thrust*ROC_speed^2/V^2;
theta=atan(ROC/ROC_speed);
ROC_thrust=sin(theta)*mass*gravity+ROC_drag;


Kv_SI=Kv/60*2*pi;
Kt=1/Kv_SI;

nominal_cell_voltage=3.7;
voltage_batt=cell_count*nominal_cell_voltage;
density=1.225;

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\Ct_coefficients.xlsx';
Ct_load=xlsread(filename);

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\Cp_coefficients.xlsx';
Cp_load=xlsread(filename);

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\eta_coefficients.xlsx';
eta_load=xlsread(filename);

p_D_load=eta_load(:,1);

Ct_load=Ct_load(:,[2:end]);
Cp_load=Cp_load(:,[2:end]);
eta_load=eta_load(:,[2:end]);


m=0;
for Diam=12:0.5:22
    for Pitch=6:0.5:22
        m=m+1;
        store(m,1)=Diam;
        store(m,2)=Pitch;
        
        
        diam_m=Diam*25.4/1000;
        p_D=Pitch/Diam;
        if(p_D>1|p_D<0.3)
            %fprintf('This prop is outside the pitch on diameter data range\n\n')
            continue;
        end
        
        %%%%check maximum thrust case
        %take an initial guess at J
        J=0.45;
        n=ROC_speed/(J*diam_m);
        p_D_upper=ceil(10*p_D)/10;
        p_D_lower=floor(10*p_D)/10;
        
        loop_count=0;
        while loop_count<50

            if(p_D_upper==p_D_lower)
                %find row in p_D_load
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est=polyval(Ct_coeff,J);
                        Cp_est=polyval(Cp_coeff,J);
                        Thrust=Ct_est*density*n^2*diam_m^4;
                        Power=Cp_est*density*n^3*diam_m^5;

                        break;
                    end

                end
            else
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_lower)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_lower=polyval(Ct_coeff,J);
                        Cp_est_lower=polyval(Cp_coeff,J);
                        break;
                    end

                end
                
                
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_upper=polyval(Ct_coeff,J);
                        Cp_est_upper=polyval(Cp_coeff,J);
                        
                        Ct_est=(p_D-p_D_lower)/0.1*Ct_est_upper-(p_D-p_D_upper)/0.1*Ct_est_lower;
                        Cp_est=(p_D-p_D_lower)/0.1*Cp_est_upper-(p_D-p_D_upper)/0.1*Cp_est_lower;
                        Thrust=(Ct_est)*density*n^2*diam_m^4;
                        Power=(Cp_est)*density*n^3*diam_m^5;

                        break;
                    end

                end
                

            end
            
            if(abs(Thrust-ROC_thrust)/ROC_thrust<0.00001)
                    break;
                else
                    J=J+(Thrust-ROC_thrust)/ROC_thrust*J*0.2;
            end
            loop_count=loop_count+1;
            n=ROC_speed/(J*diam_m);
        end
        
        J_ROC=J;
        n_ROC=n;
        Cq_ROC=Cp_est/(2*pi);
        Q_ROC=Cq_ROC*density*n_ROC^2*diam_m^5;
        
        %check the electrical case for maximum
        I_ROC=Q_ROC/Kt+Io;
        V_ROC=n_ROC*60/Kv+I_ROC*Rm;
        
        
        
        store(m,3)=n_ROC;
        store(m,4)=Q_ROC;
        store(m,5)=Thrust;
        store(m,6)=Power;
        store(m,7)=I_ROC;
        store(m,8)=V_ROC;
        store(m,9)=I_ROC*V_ROC;
        
        
        if(V_ROC>voltage_batt)
            %fprintf('This props needs more torque\n\n');
            continue;
        end
        
        %%%now look at the cruise case!
        J=0.45;
        n=V/(J*diam_m);
        p_D_upper=ceil(10*p_D)/10;
        p_D_lower=floor(10*p_D)/10;
        
        loop_count=0;
        while loop_count<50

            if(p_D_upper==p_D_lower)
                %find row in p_D_load
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est=polyval(Ct_coeff,J);
                        Cp_est=polyval(Cp_coeff,J);
                        Thrust=Ct_est*density*n^2*diam_m^4;
                        Power=Cp_est*density*n^3*diam_m^5;

                        break;
                    end

                end
            else
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_lower)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_lower=polyval(Ct_coeff,J);
                        Cp_est_lower=polyval(Cp_coeff,J);
                        break;
                    end

                end
                
                
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_upper=polyval(Ct_coeff,J);
                        Cp_est_upper=polyval(Cp_coeff,J);
                        
                        Ct_est=(p_D-p_D_lower)/0.1*Ct_est_upper-(p_D-p_D_upper)/0.1*Ct_est_lower;
                        Cp_est=(p_D-p_D_lower)/0.1*Cp_est_upper-(p_D-p_D_upper)/0.1*Cp_est_lower;
                        Thrust=(Ct_est)*density*n^2*diam_m^4;
                        Power=(Cp_est)*density*n^3*diam_m^5;

                        break;
                    end

                end
                

            end
            
            if(abs(Thrust-cruise_thrust)/cruise_thrust<0.00001)
                    break;
                else
                    J=J+(Thrust-cruise_thrust)/cruise_thrust*J*0.2;
            end
            loop_count=loop_count+1;
            n=V/(J*diam_m);
        end
        J_cruise=J;
        n_cruise=n;
        Cq_cruise=Cp_est/(2*pi);
        Q_cruise=Cq_cruise*density*n_cruise^2*diam_m^5;
        
        I_cruise=Q_cruise/Kt+Io;
        V_cruise=n_cruise*60/Kv+I_cruise*Rm;
        
        store(m,10)=n_cruise;
        store(m,11)=Q_cruise;
        store(m,12)=Thrust;
        store(m,13)=Power;
        store(m,14)=I_cruise;
        store(m,15)=V_cruise;
        store(m,16)=I_cruise*V_cruise;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        J=0.45;
        n=ROC_speed/(J*diam_m);
        p_D_upper=ceil(10*p_D)/10;
        p_D_lower=floor(10*p_D)/10;
        n=n_ROC;
        loop_count=0;
        while loop_count<999
            n=n+0.5;
            J=ROC_speed/(n*diam_m);
            if(p_D_upper==p_D_lower)
                %find row in p_D_load
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est=polyval(Ct_coeff,J);
                        Cp_est=polyval(Cp_coeff,J);
                        Thrust=Ct_est*density*n^2*diam_m^4;
                        Power=Cp_est*density*n^3*diam_m^5;

                        break;
                    end

                end
            else
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_lower)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_lower=polyval(Ct_coeff,J);
                        Cp_est_lower=polyval(Cp_coeff,J);
                        break;
                    end

                end
                
                
                for i=1:length(p_D_load)

                    if(p_D_load(i)==p_D_upper)
                        Ct_coeff=Ct_load(i,:);
                        Cp_coeff=Cp_load(i,:);
                        Ct_est_upper=polyval(Ct_coeff,J);
                        Cp_est_upper=polyval(Cp_coeff,J);
                        
                        Ct_est=(p_D-p_D_lower)/0.1*Ct_est_upper-(p_D-p_D_upper)/0.1*Ct_est_lower;
                        Cp_est=(p_D-p_D_lower)/0.1*Cp_est_upper-(p_D-p_D_upper)/0.1*Cp_est_lower;
                        Thrust=(Ct_est)*density*n^2*diam_m^4;
                        Power=(Cp_est)*density*n^3*diam_m^5;

                        break;
                    end

                end
                

            end
            
            
            loop_count=loop_count+1;
            n=ROC_speed/(J*diam_m);
            J_max=J;
            
            Cq_max=Cp_est/(2*pi);
            Q_max=Cq_max*density*n^2*diam_m^5;
            
            I_max=Q_max/Kt+Io;
            V_max=n*60/Kv+I_max*Rm;
            
            n_max=n;
            Q_max=Q_ROC;
            Thrust_max=Thrust;
            Power_max=Power;
            
            if(V_max>voltage_batt)
                break;
            end
        end
        
        
        %%%%%%%%%%%%%%%%%%%%
        
        fprintf('The prop is a %d x %d \n',Diam,Pitch)
        fprintf('The cruise power consumption is %f Watts at a throttle of %f \n',I_cruise*V_cruise,(I_cruise*V_cruise/min(Power_max,Motor_max_power))^(3/7)*100);
        fprintf('The climb power comsumption is %f Watts at a throttle of %f \n\n',I_ROC*V_ROC,(I_ROC*V_ROC/min(Power_max,Motor_max_power))^(3/7)*100);
        
        
        
        
    end
end


store=num2cell(store);
store=vertcat({'Diam','Pitch','n_ROC','Q_ROC','Thrust_ROC','Power_ROC','I_ROC','V_ROC','I*V_ROC','n_cruise','Q_cruise','Thrust_cruise','Power_cruise','I_cruise','V_cruise','I*V_cruise'},store)
xlswrite('C:\Users\Adam Bell\Documents\University\2017\FYP\Code\output_given_motor_find_propeller.xlsx',store);


