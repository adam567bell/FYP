%read in the coefficients found for approximate curves
clear
clc
close all


speed=0


filename='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\Ct_coefficients.xlsx';
Ct_load=xlsread(filename);

filename='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\Cp_coefficients.xlsx';
Cp_load=xlsread(filename);

filename='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\eta_coefficients.xlsx';
eta_load=xlsread(filename);

p_D_load=eta_load(:,1);

Ct_load=Ct_load(:,[2:end]);
Cp_load=Cp_load(:,[2:end]);
eta_load=eta_load(:,[2:end]);

figure;
%scatter(0,0)
hold on
%run through the efficiency generation for a given thrust for diam, p/d
%iterations

target_vel=30;%m/s
target_thrust=54.8416;%0.7*9.81;%newtons

for i=1:length(p_D_load)
    store_efficiency=[];
    store_speed_rot=[];
    for diam=15:25
        
        diam=diam;
        pitch=diam*p_D_load(i);
        p_D=pitch/diam;
        diam_m=diam*25.4/1000;
        pitch_m=pitch*25.4/1000;
        
        if(pitch<-0.5 | pitch>99.5 | diam<-0.5 | diam>99.5)
            continue;
        end
        
        
        density=1.225;
        
        p1=Ct_load(i,:);
        p2=Cp_load(i,:);
        p3=eta_load(i,:);

        j=0.45;%this is a guessed first point.....
        
        error=1; %abs((actual_thrust-target_thrust)/actual_thrust)
        %loop
        count=0;
        
        while abs(error)>0.0005
            speed_rot=target_vel/(diam_m*j);

            Ct_est=polyval(p1,j);
            thrust_est=Ct_est*density*speed_rot^2*diam_m^4;
            efficiency=polyval(p3,j);
            
            error=(thrust_est-target_thrust)/thrust_est;
            j=j+0.05*error;%0.15
            count=count+1;
            if (count>=50 & abs(error)>0.01)
                break;
            end
            if (count>=100)
                break;
            end
        end
        tip_speed=speed_rot*2*pi*diam_m/2;
        speed_of_sound=343;%m/s
        if(abs(error)<0.005 & efficiency<1 & tip_speed<0.7*speed_of_sound)
            %scatter(efficiency, speed_rot);
            %hold on
            name=strcat(num2str(diam),'x',num2str(pitch));
            if(speed==1)
                
            text(efficiency,speed_rot,name);
            
            else
            text(efficiency,polyval(p2,j)/(2*pi)*1.225*speed_rot^2*diam_m^5,name);
            end
            name
            
            speed_rot
            efficiency
            store_efficiency(end+1)=efficiency;
            if(speed==1)
            store_speed_rot(end+1)=speed_rot;
                
            else
            store_speed_rot(end+1)=polyval(p2,j)/(2*pi)*1.225*speed_rot^2*diam_m^5;
            end
            
            fprintf('COMPLETED; NEXT PROP\n\n')
        end
            
    end
    %p_fit=polyfit(store_speed_rot,store_efficiency,3);
    %x=linspace(min(store_speed_rot),max(store_speed_rot),100);
    %plot(polyval(p_fit,x),x,'r.')
    scatter(store_efficiency,store_speed_rot);
    hold on;
end
xlabel('eta')
if(speed==1)
    ylabel('speed of rotation (rev/s)')
else
ylabel('Q (Nm)')
end
        
       



