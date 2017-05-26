function [valid,J,n,calc_thrust,calc_power,calc_torque]=plane_propeller_conditions_given_thrust_requirement(req_thrust,speed,diam_m,pitch_m,Ct_load,Cp_load,eta_load,p_D_load,density)
J=0;
n=0;
calc_thrust=0;
calc_power=0;
calc_torque=0;
%used as a placeholder so that it is possible to exit the loop and remember
%that something failed, such as a p/D outside the relevant datarange
valid=1;

%calculate the p/D of the propeller for checks
p_D=pitch_m/diam_m;
%check that p/D is in the relevant range of the data
if(p_D<0.3|p_D>1.0)
    valid=0;
    return
end

%need an initial guess of J which will be corrected until no error in
%thrust required vs thrust achieved
J=0.45;
n=speed/(J*diam_m);

%this is to account for the fact that the p/D data is in steps of 0.1 so if
%a p/D is actually 0.54 (example) then it is necessary to interpolate
%between p/D=0.5 and 0.6
p_D_upper=ceil(10*p_D)/10;
p_D_lower=floor(10*p_D)/10;

%loop counter so that if there is no valid solution it doesn't search
%forever
loop_count=0;

%this uses the J value to work out how much thrust the propeller will
%generate and compares it to the required thrust. It then makes a
%correction to J based on this error and reruns until the required thrust
%and the generated thrust are equal
while loop_count<50
    
    %p/D could be a multiple of 0.1 in which case no interpolation is
    %needed
    if(p_D_upper==p_D_lower)
         %find row in p_D_load
         for i=1:length(p_D_load)
             %if the correct row has been found
             if(p_D_load(i)==p_D_upper)
                 %then save all of the coeffs for that row and calculate
                 %the Ct and Cp and Power and Thrust
                 Ct_coeff=Ct_load(i,[2:end]);
                 Cp_coeff=Cp_load(i,[2:end]);
                 %Ct_est=polyval(Ct_coeff,J);
                 Ct_est=Ct_coeff(1)*J^2+Ct_coeff(2)*J+Ct_coeff(3);
                 %Cp_est=polyval(Cp_coeff,J);
                 Cp_est=Cp_coeff(1)*J^2+Cp_coeff(2)*J+Cp_coeff(3);
                 calc_thrust=Ct_est*density*n*n*diam_m*diam_m*diam_m*diam_m;
                 calc_power=Cp_est*density*n*n*n*diam_m*diam_m*diam_m*diam_m*diam_m;

                 break;
             end
         end
         
    
    %if p/D was a multiple of 0.1 then we have now solved for
    %everything
    %if it is not a multiple of 0.1 then we need to to consider this case
    %and do interpolation
    
    elseif p_D_upper~=p_D_lower
        %iterate through all the possible p_D values
        for i=1:length(p_D_load)
            %find the row where the p_D is equal to the lower case and
            if(p_D_load(i)==p_D_lower)
                %save all these values for the lower case
                %Ct_coeff_lower=Ct_load(i,[2:end]);
                %Cp_coeff_lower=Cp_load(i,[2:end]);
                %Ct_est=polyval(Ct_coeff,J);
                Ct_est_lower=Ct_load(i,2)*J^2+Ct_load(i,3)*J+Ct_load(i,4);
                %Cp_est=polyval(Cp_coeff,J);
                Cp_est_lower=Cp_load(i,2)*J^2+Cp_load(i,3)*J+Cp_load(i,4);
                
            end
            %find the row where p_D is equal to the upper vase and
            if(p_D_load(i)==p_D_upper)
                %save all these values for the upper case
                %Ct_coeff_upper=Ct_load(i,[2:end]);
                %Cp_coeff_upper=Cp_load(i,[2:end]);
                %Ct_est=polyval(Ct_coeff,J);
                Ct_est_upper=Ct_load(i,2)*J^2+Ct_load(i,3)*J+Ct_load(i,4);
                %Cp_est=polyval(Cp_coeff,J);
                Cp_est_upper=Cp_load(i,2)*J^2+Cp_load(i,3)*J+Cp_load(i,4);
                
                
                %now the case at each side of the interpolation is known so
                %it is possible to estimate by interpolation
                Ct_est=(p_D-p_D_lower)/0.1*Ct_est_upper-(p_D-p_D_upper)/0.1*Ct_est_lower;
                Cp_est=(p_D-p_D_lower)/0.1*Cp_est_upper-(p_D-p_D_upper)/0.1*Cp_est_lower;
                calc_thrust=(Ct_est)*density*n*n*diam_m*diam_m*diam_m*diam_m;
                calc_power=(Cp_est)*density*n*n*n*diam_m*diam_m*diam_m*diam_m*diam_m;
                break;
            end
        end
    end
    %At this point, Thrust and Power and defined for any p_D
    %Now it is necessary to correct between the calculated thrust and the
    %desired thrust
    
    if(abs(calc_thrust-req_thrust)/req_thrust<0.00001)
        break;
    else
        %This is the correction to J and 0.2 as a multiplication of the
        %error was found to converge nicely because it was quick but not so
        %quick that it oscillated
        J=J+(calc_thrust-req_thrust)/req_thrust*J*0.2;
    end
    
    %iterate the loop counter
    loop_count=loop_count+1;
    %update the speed of rotation based on the updated J valud
    n=speed/(J*diam_m);
    
end

%check that it hasn't aborted the calculations due to not converging on a
%solution
if loop_count>=50
    valid=0;
    return;
end

%if a valid solution was found then calculate the torque
Cq_est=Cp_est/(2*pi);
calc_torque=Cq_est*density*n^2*diam_m^5;

%check tip speed
tip_speed=n*2*pi*diam_m/2;

%compare to maximum tip speed which I have elected to be 70% of speed of
%sound
max_tip_speed=340.29*0.7;
if(tip_speed>max_tip_speed)
    valid=0;
    return;
end

end