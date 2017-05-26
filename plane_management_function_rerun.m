function [storage,valid_return]=plane_management_function_rerun(Ct_load,Cp_load,eta_load,Diam,Pitch,cell_count,cruise_speed,cruise_thrust,mass,ROC,ROC_speed,ROC_drag,predict_Rm,predict_Io,predict_motor_weight,Kv,motor_max_power,Rm_input,Io_input,motor_weight_input,ESC_rating,max_speed_rotation,max_motor_weight)
valid_return=1;
%THIS IS AN ADAPTER VERSION OF Plane_management_function.m as it only needs
%to run a single propeller

%define generic constants
density=1.225;%kg/m^3
gravity=9.81;%m/s^2
p_D_load=Ct_load(:,1);
nominal_cell_voltage=3.7;
voltage_batt=nominal_cell_voltage*cell_count;
storage=zeros(1,41);
m=1;


%iterate through all props, pitch and diam as per structure in the
%plane_solutions_given_flight_conditions file
for i=1:1%length(avail_props_diam)
    %find all propeller input values
    Diam=Diam;
    Pitch=Pitch;
    diam_m=Diam*25.4/1000;
    pitch_m=Pitch*25.4/1000;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Maximum ROC case %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %This case is run first as smaller props get knocked out as having to
    %spin too fast to achieve the maximum thrust case of ROC
    
    if(ROC_speed==-1)
        ROC_speed=cruise_speed;
    else
        %do nothing
    end
    
    %the angle of flight, which works out the component of mass which also needs to be counteracted by the thrust 
    theta=atan(ROC/ROC_speed);
    %if ROC_drag==-1 then this implies that the configuration of the
    %aircraft in the maximum ROC is the same as in cruise.
    if(ROC_drag==-1)
        ROC_drag=cruise_thrust*(ROC_speed^2/cruise_speed^2);
    else
        %no need to change the value as it is already specified
    end
    
    
    %ROC thrust is the thrust to overcome the weight component plus the
    %aerodynamic drag
    ROC_thrust=sin(theta)*mass*gravity+ROC_drag;
    
    
    %Now we need to solve FOR this propeller, how fast it has to spin to
    %produce the required thrust. And the resultant power used and torque
    %required. The speed of rotation and torque are then fed into the motor
    %model to find the motor which can produce the torque at this speed and
    %the power consumed is relevant to the power consumed by the propeller
    %which is ideally minimised.
    [valid_ROC,J_ROC,n_ROC,calc_thrust_ROC,calc_power_ROC,calc_torque_ROC]=plane_propeller_conditions_given_thrust_requirement(ROC_thrust,ROC_speed,diam_m,pitch_m,Ct_load,Cp_load,eta_load,p_D_load,density);
    
    %There are a couple of places in this function, where if it fails to
    %find a solution it will set valid to 0 so that this propeller can be
    %dropped.
    if(valid_ROC==0 | n_ROC<0 | calc_torque_ROC<0 | n_ROC>(max_speed_rotation/60))
        %need to reject this propeller so just continue
        valid_return=-1;
    end
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Cruise case %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %Now we need to solve FOR this propeller, how fast it has to spin to
    %produce the required thrust. And the resultant power used and torque
    %required. The speed of rotation and torque are then fed into the motor
    %model to find the motor which can produce the torque at this speed and
    %the power consumed is relevant to the power consumed by the propeller
    %which is ideally minimised.
    [valid_cruise,J_cruise,n_cruise,calc_thrust_cruise,calc_power_cruise,calc_torque_cruise]=plane_propeller_conditions_given_thrust_requirement(cruise_thrust,cruise_speed,diam_m,pitch_m,Ct_load,Cp_load,eta_load,p_D_load,density);
    
    if(valid_cruise==0 | n_cruise<0 | calc_torque_cruise<0)
        %need to reject this propeller so just continue
        valid_return=-2;
    end
    
    %minimum Kv which will achieve the desired speed if RPM=Kv*V, therefore
    %no Kv smaller than this will be appropriate. The spacing of Kv is then
    %spaced based on the Kv as recommending a Kv=1000 motor vs a Kv=1010
    %motor is not reasonable but recommending a Kv=150 vs a Kv=160 motor
    %does make sense
    
    
    %The minimum power that the motor supplies must be great than the
    %Maximum power required by the propeller. I have spaced accordingly
    %again
    
    
    for Kv=Kv
        for min_max_power=motor_max_power
            %find motor efficiency
            [Rm,Io,motor_weight,motor_diam,motor_length]=plane_motor_model(Kv,min_max_power);
            
            if(predict_Rm==0)
                Rm=Rm_input;
            end
            if(predict_Io==0)
                Io=Io_input;
            end
            if(predict_motor_weight==0)
                motor_weight=motor_weight_input;
            end
            
            
            Kt=60/(2*pi*Kv);
            I_ROC=calc_torque_ROC/Kt+Io;
            V_ROC=n_ROC*60/Kv+I_ROC*Rm;
            %limiting that maximum throttle is 85% to avoid the exponential
            %losses which seem to occur
            if(V_ROC>voltage_batt*0.85)
                valid_return=-3;
            end
            if(motor_weight>max_motor_weight)
                valid_return=-4
            end;
            I_cruise=calc_torque_cruise/Kt+Io;
            V_cruise=n_cruise*60/Kv+I_cruise*Rm;
            
            %Also defined from formula 5
            %http://web.mit.edu/drela/Public/web/qprop/motorprop.pdf
            motor_eff_ROC=calc_power_ROC/(I_ROC*V_ROC);
            motor_eff_cruise=calc_power_cruise/(I_cruise*V_cruise);
            
            
            %find ESC efficiency in cruise and in climb
            [max_power,max_current,max_thrust,n_max,max_torque]=plane_maximum_throttle_case(Ct_load,Cp_load,eta_load,p_D_load,density,Rm,Io,voltage_batt,Kv,I_ROC,diam_m,pitch_m,cruise_speed,cruise_thrust);
            %ESC efficiency need to know the maximum power that can be
            %drawn through the system
            n_max=n_max;
            torque_max=max_torque;
            thrust_max=max_thrust;
            
            power_max=max_power;
            I_max=max_current;
            V_max=voltage_batt;
            
            %these maximum power numbers can now be used to calculate the
            %ESC behaviour as per the paper labelled 'development of a
            %dynamic medel for electric uavs'
            esc_rating=ESC_rating;%Note that this must be updated to be consistent with the app
            
            %Ri_esc was found from ecalc generic values and then a curve
            %was fitted
            Ri_esc=0.1385*esc_rating^-0.868;
            %PTF=2.1 was assumed as a constant which is known to be false
            %but the efficiency of the ESC is fairly high anyway and
            %literally no better model could be found.
            PTF=2.1;
            
            PWS_ROC=I_ROC*V_ROC/power_max;
            PWS_cruise=I_cruise*V_cruise/power_max;
            
            
            
            %0.99 to account for 100% at full throttle issue
            ESC_eff_ROC=0.99*(voltage_batt-Ri_esc-PTF*(1-PWS_ROC))/voltage_batt;
            ESC_eff_cruise=0.99*(voltage_batt-Ri_esc-PTF*(1-PWS_cruise))/voltage_batt;
           
            if(min_max_power<I_ROC*V_ROC/ESC_eff_ROC)
                valid_return==-5;
            end
            
            %save all relevant values
            storage(m,1)=cell_count;
            storage(m,2)=cruise_speed;
            storage(m,3)=cruise_thrust;
            storage(m,4)=mass;
            storage(m,5)=ROC;
            storage(m,6)=ROC_speed;
            storage(m,7)=Kv;
            storage(m,8)=min_max_power;
            storage(m,9)=motor_weight;
            storage(m,10)=Rm;
            storage(m,11)=Io;
            storage(m,12)=motor_eff_ROC;
            storage(m,13)=motor_eff_cruise;
            storage(m,14)=Diam;
            storage(m,15)=Pitch;
            storage(m,16)=n_ROC;
            storage(m,17)=calc_torque_ROC;
            storage(m,18)=calc_thrust_ROC;
            storage(m,19)=calc_power_ROC;
            storage(m,20)=I_ROC;
            storage(m,21)=V_ROC;
            storage(m,22)=I_ROC*V_ROC;
            storage(m,23)=I_ROC*V_ROC/ESC_eff_ROC;
            storage(m,24)=n_max;
            storage(m,25)=torque_max;
            storage(m,26)=thrust_max;
            storage(m,27)=power_max;
            storage(m,28)=cruise_speed;
            storage(m,29)=I_max;
            storage(m,30)=V_max;
            storage(m,31)=I_max*V_max;
            storage(m,32)=ESC_eff_ROC;
            storage(m,33)=ESC_eff_cruise;
            storage(m,34)=n_cruise;
            storage(m,35)=calc_torque_cruise;
            storage(m,36)=calc_thrust_cruise;
            storage(m,37)=calc_power_cruise;
            storage(m,38)=I_cruise;
            storage(m,39)=V_cruise;
            storage(m,40)=I_cruise*V_cruise;
            storage(m,41)=I_cruise*V_cruise/ESC_eff_cruise;
            
            m=m+1;
        end
    end
end


end


