

clear
clc
close all

base_name='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
filename='apcsp_14x13.xlsx';
target_vel=15;%m/s
target_thrust=4;%newtons


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

%solve for n

j=0.4

error=1; %abs((actual_thrust-target_thrust)/actual_thrust)
%loop
count=0;
while abs(error)>0.005


speed_rot=target_vel/(diam*j)

Ct_est=polyval(p1,j);
thrust_est=Ct_est*density*speed_rot^2*diam^4
efficiency=polyval(p3,j)

error=(thrust_est-target_thrust)/thrust_est
j=j+0.2*error
count=count+1;
if count>=150
    break;
end
end


