%%change from part 1 is that now I want to search through a whole database
%%and store the more efficient point of operation for each prop on a graph
%%of efficiency vs speed?

clear
clc
close all

target_vel=18;%m/s
target_thrust=0.6*9.81;%newtons

base_name='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Select UAS typical propellers';


A=dir(base_name)
figure;
%scatter(0,0)
hold on

for i=3:length(A)
    filename=A(i).name;
    

    

    %filename='apcsp_14x13.xlsx';



    marker_1=0;
    marker_2=0;
    marker_3=0;
    for k=1:length(filename)
            if(filename(k)=='_')
                marker_1=k;
            elseif(filename(k)=='x')
                marker_2=k;
            elseif(filename(k)=='.' & filename(k+1)=='x' & filename(k+2)=='l')
                marker_3=k;
                break;
            end
    end

    diam=str2num(filename([marker_1+1:marker_2-1]));
    pitch=str2num(filename([marker_2+1:marker_3-1]));
    p_D=pitch/diam;
    if(pitch<3.5 | pitch>8.5 | diam<7.5 | diam>12.5)
        continue;
    end
    
    if(strfind(A(i).name,'apc')>0)
        
    else
        continue;
    end
    
    
    
%if(abs(error)<0.005 & diam<11.5*25.4/1000 & diam >10.5*25.4/1000 & pitch>7.5 & pitch <11.5)% & diam<10*25.4/1000)
    
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

    j=0.55

    error=1; %abs((actual_thrust-target_thrust)/actual_thrust)
    %loop
    count=0;
    while abs(error)>0.005


        speed_rot=target_vel/(diam*j);

        Ct_est=polyval(p1,j);
        thrust_est=Ct_est*density*speed_rot^2*diam^4;
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

        i
        count
        j
        A(i).name
    end
    if(abs(error)<0.005 & efficiency<1 & speed_rot<300)
        scatter(efficiency, speed_rot);
        text(efficiency,speed_rot,A(i).name(1:end-5));
        A(i).name
        fprintf('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh')
        efficiency
        speed_rot
    end
end



