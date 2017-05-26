function [max_power,max_current,max_thrust,n_max,torque_max]=plane_maximum_throttle_case(Ct_load,Cp_load,eta_load,p_D_load,density,Rm,Io,voltage_batt,Kv,I_ROC,diam_m,pitch_m,cruise_speed,cruise_thrust)

I=I_ROC*1.8;
Kt=1/(Kv/60*2*pi);
speed=cruise_speed;


error=1;
loop_counter=1;
while abs(error)>0.001
    
    req_torque=Kt*(I-Io);
  
    
    [valid,J,n,calc_thrust,calc_power,calc_torque]=plane_propeller_conditions_given_torque_requirement(req_torque,speed,diam_m,pitch_m,Ct_load,Cp_load,eta_load,p_D_load,density,cruise_thrust);
    
    I_req=-(n*60/Kv-voltage_batt)/Rm;
    
    %this assumes a constant speed of the cruise_speed
    error=(I-I_req)/I_req;
    I=I-I*error*0.35;
    loop_counter=loop_counter+1;
    if(loop_counter>=15)
        break
    end
end
max_power=I*voltage_batt;
max_current=I;
max_thrust=calc_thrust;
n_max=n;
torque_max=req_torque;

if(valid==0|max_current<=I_ROC)
    max_power=3*I_ROC*voltage_batt;
    max_current=99999;
end
    
end