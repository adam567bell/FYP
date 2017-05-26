function [store]=motor_prop_search(Ct_load,Cp_load,eta_load,avail_props_diam,avail_props_pitch,cell_count,cruise_thrust,ROC,velocity_cruise,mass)




Kv=[];%RPM/V
Rm=[];%Ohms
Io=[];%A
Io_voltage=[];%V
Motor_max_power=[];%W


V=velocity_cruise;%m/s
store=zeros(999,28);


gravity=9.81;%yep
ROC_speed=V;%assume rate of climb at the cruise speed
ROC_drag=cruise_thrust*ROC_speed^2/V^2;
theta=atan(ROC/ROC_speed);
ROC_thrust=sin(theta)*mass*gravity+ROC_drag;


%Kv_SI=Kv/60*2*pi;
%Kt=1/Kv_SI;

nominal_cell_voltage=3.7;
voltage_batt=cell_count*nominal_cell_voltage;
density=1.225;

p_D_load=eta_load(:,1);

Ct_load=Ct_load(:,[2:end]);
Cp_load=Cp_load(:,[2:end]);
eta_load=eta_load(:,[2:end]);


m=0;
% for Diam=avail_props_diam
%     for Pitch=avail_props_pitch
for loop=1:length(avail_props_diam)
    Diam=avail_props_diam(loop);
    Pitch=avail_props_pitch(loop);
        m=m+1;
        store(m,1)=cell_count;
        store(m,2)=cruise_thrust;
        store(m,3)=ROC;
        store(m,4)=velocity_cruise;
        store(m,5)=mass;
        store(m,6)=Diam;
        store(m,7)=Pitch;
        
        
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
        if(loop_count>=50)
            continue;
        end
        J_ROC=J;
        n_ROC=n;
        Cq_ROC=Cp_est/(2*pi);
        Q_ROC=Cq_ROC*density*n_ROC^2*diam_m^5;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Motor Values
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Kv_min=ceil(n_ROC*60/voltage_batt/10)*10;
        for Kv=Kv_min:10:99999
            Kv_store=Kv;
            min_max_power=ceil(Power/100)*100;%this uses %power=%thr^(3/7) which should mean 85% thr
            for max_power=min_max_power
                
                %this was derived from motor database
                motor_length=6.5088*(max_power)^0.2964;
                
                %this was derived from motor database timelock1.xlsx
                %maxpower=0.008277638*(length*diam)^1.513392202
                %reversed poorly!!
                motor_diam=1/motor_length*41.165101*(max_power)^0.58308731;
                
                %this was derived from motor database timelock1.xlsx
                Rm=3285770636.3*(motor_length*motor_diam.^2*Kv)^-1.0197542*10^-3;
                
                %this was derived from motor database timelock1.xlsx
                Io=7.50785*10^-7*(motor_length*motor_diam.^2*Kv)^0.805527904;
                Motor_max_power=max_power;
            end 
            Kt=60/(2*pi*Kv_store);
        %check the electrical case for maximum
            I_ROC=Q_ROC/Kt+Io;
            V_ROC=n_ROC*60/Kv_store+I_ROC*Rm;
            if(V_ROC<voltage_batt*0.8)%0.8 to make sure that it doens't occur at full throttle
                break;
            end

            
        end
        %http://web.mit.edu/drela/Public/web/qprop/motorprop.pdf
        motor_efficiency_ROC=(1-Io*Rm/(V_ROC-n_ROC*2*pi/(Kv_store*2*pi/60)))*n_ROC*2*pi/(Kv_store*2*pi/60*V_ROC);
        
        %from motor database
        weight_motor=0.1976*(Motor_max_power)+54.431
        
        store(m,8)=n_ROC;
        store(m,9)=Q_ROC;
        store(m,10)=Thrust;
        store(m,11)=Power;
        store(m,12)=I_ROC;
        store(m,13)=V_ROC;
        store(m,14)=I_ROC*V_ROC;
        store(m,15)=Rm;
        store(m,16)=Io;
        store(m,17)=max_power;
        store(m,18)=Kv_store;
        store(m,19)=weight_motor;

        
        
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
        if(loop_count>=50)
            continue;
        end
        J_cruise=J;
        n_cruise=n;
        Cq_cruise=Cp_est/(2*pi);
        Q_cruise=Cq_cruise*density*n_cruise^2*diam_m^5;
        
        I_cruise=Q_cruise/Kt+Io;
        V_cruise=n_cruise*60/Kv+I_cruise*Rm;
        
        %http://web.mit.edu/drela/Public/web/qprop/motorprop.pdf
        motor_efficiency_cruise=(1-Io*Rm/(V_cruise-n_cruise*2*pi/(Kv_store*2*pi/60)))*n_cruise*2*pi/(Kv_store*2*pi/60*V_cruise);
        
        store(m,20)=n_cruise;
        store(m,21)=Q_cruise;
        store(m,22)=Thrust;
        store(m,23)=Power;
        store(m,24)=I_cruise;
        store(m,25)=V_cruise;
        store(m,26)=I_cruise*V_cruise;
        store(m,27)=motor_efficiency_ROC;
        store(m,28)=motor_efficiency_cruise;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        p_D_upper=ceil(10*p_D)/10;
        p_D_lower=floor(10*p_D)/10;
        max_speed=ROC_speed;
        error=1;
        I=40;%Amps
        count=0;
        while abs(error)>0.01
            count=count+1;
            if(count>999)
                I=I_ROC*2.5;
                break;
            end
            n_max=(Kv/60)*(voltage_batt-Rm*I);
            J=max_speed/(n*diam_m);%note I don't like that it uses the same speed as the aircraft would actually be going faster
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
            max_speed=max_speed*sqrt(Thrust/cruise_thrust);
            Cq=Cp_est/(2*pi);
            Torque_req=Cq*1.225*n_max^2*diam_m^5;
            Torque_avail=Kt*(I-Io);
            error=(Torque_req-Torque_avail)/Torque_avail;
            I=I+error;
        end
        Power_percent_cruise=I_cruise*V_cruise/(I*voltage_batt);
        Power_percent_ROC=I_ROC*V_ROC/(I*voltage_batt);
        
        
        
        %%%%%%%%%%%%%%%%%%%%model for esc
        %development of a dynamic propulsion system paper
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%
        
        esc_rating=ceil(I_ROC*1.2/5)*5;
        
        %%I just punch in the generic esc from ecalc over different rated
        %%currents and grabbed the resistance and threw into excel with
        %%power trendline
        Ri_esc=0.1385*esc_rating^-0.868;
        PTF=2.1;
        
        eff_ROC=(V_ROC-Ri_esc-PTF*(1-Power_percent_ROC))/V_ROC;
        eff_cruise=(V_cruise-Ri_esc-PTF*(1-Power_percent_cruise))/V_cruise;
        if(I==I_ROC*2.5)
            eff_ROC=0.85;
            eff_cruise=0.85;
        end
        
        store(m,29)=eff_ROC;
        store(m,30)=eff_cruise;
        store(m,31)=store(m,14)/eff_ROC;
        store(m,32)=store(m,26)/eff_cruise;
        
        
%end to match the pitch/diam being unmatched with purchaseable        
        
        %%%%%%%%%%%%%%%%%%%%
        
%         fprintf('The prop is a %d x %d \n',Diam,Pitch)
%         fprintf('The cruise power consumption is %f Watts at a throttle of %f \n',I_cruise*V_cruise,(I_cruise*V_cruise/min(Power_max,Motor_max_power))^(3/7)*100);
%         fprintf('The climb power comsumption is %f Watts at a throttle of %f \n\n',I_ROC*V_ROC,(I_ROC*V_ROC/min(Power_max,Motor_max_power))^(3/7)*100);
%         
        
        
        
    end

logical=store(:,end)>0;
store=store(logical,:);


end
