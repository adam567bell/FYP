%comparison to Grundlach page292, heat map of the eta_p,nonideal

clear
clc
%close all

base_name='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
filename='apce_8x8.xlsx';
title_name=filename;
target_vel=15;%m/s
target_thrust=4;%newtons

count_vel=1;


marker_1=0;
        marker_2=0;
        marker_3=0;
        for i=1:length(filename)
                if(filename(i)=='_')
                    marker_1=i;
                elseif(filename(i)=='x')
                    marker_2=i;
                elseif(filename(i)=='.')
                    marker_3=i;
                    break;
                end
        end

        diam=str2num(filename([marker_1+1:marker_2-1]));
        pitch=str2num(filename([marker_2+1:marker_3-1]));



        diam=25.4*diam/1000;
        density=1.225;


        filename=strcat(base_name,'\',filename);
        store=xlsread(filename);
        J=store(:,1);
        Ct=store(:,2);
        Cp=store(:,3);
        eta=store(:,4);


        p1=polyfit(J,Ct,4);
        p2=polyfit(J,Cp,4);
        p3=polyfit(J,eta,6);
        


vel_lower=13
vel_step=0.5
vel_upper=20

thr_lower=3%N
thr_step=0.5
thr_upper=10

plotted=zeros(round(vel_upper-vel_lower)/vel_step+1,(round(thr_upper-thr_lower)/thr_step+1));

for target_vel=vel_lower:vel_step:vel_upper
    
    count_thrust=1;
    for target_thrust=thr_lower:thr_step:thr_upper
        %%need to add case for if it fails based on polyfit (out of range
        %%of reality!!!!)


        

        %solve for n

        j=0.4;

        error=1; %abs((actual_thrust-target_thrust)/actual_thrust)
        %loop
        count=0;
        while abs(error)>0.002


        speed_rot=target_vel/(diam*j);

        Ct_est=polyval(p1,j);
        thrust_est=Ct_est*density*speed_rot^2*diam^4;
        efficiency=polyval(p3,j);

        error=(thrust_est-target_thrust)/thrust_est;
        j=j+0.2*error;
        count=count+1;
        if count>=150
            break;
        end
        
        %store
        
        
        end
        
        %%now use grundlach method
        area=pi/4*(diam)^2;
        delta_v=sqrt(target_vel.^2+2*(target_thrust/9.81)/(1.225*area)-target_vel);
        np_ideal=1/((delta_v)/(2*target_vel)+1);
        
        
        np_ideal
        efficiency
        target_thrust
        target_vel
        
        %this is to stop messing with the plot but any values of 0.7
        %must be completely discounted as unuseable
        if(efficiency/np_ideal>=0.75)% & efficiency/np_ideal<=1)
            plotted(count_vel,count_thrust)=efficiency/np_ideal;
        %elseif(efficiency/np_ideal>=1)
        %    plotted(count_vel,count_thrust)=1;
        elseif(efficiency/np_ideal<=0.75)
            plotted(count_vel,count_thrust)=0.75;
        end
        count_thrust=count_thrust+1;
    end
    count_vel=count_vel+1
end

%%Now use the grundlach method
figure;
contourf([thr_lower:thr_step:thr_upper],[vel_lower:vel_step:vel_upper],plotted)
colorbar('southoutside')
title(title_name);
xlabel('Force(Newtons)');
ylabel('Speed(m/s)');
%HeatMap(plotted,'Colormap',redbluecmap)
%hold on
%colorbar
