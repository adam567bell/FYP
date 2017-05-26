%previously 'ignore11.m'

%plot all (maybe just some) of the classes which have 10x5 in their name

%search through name list, find hits for the given input (make it multiple
%inputs)



%note to self, need to change the directory to a new folder which only has
%sensible props and none of the stupidly blunt ones which we won't run!
%


clear
clc
close all

figure(1)
hold on
figure(2)
hold on
figure(3)
hold on

counter=1;

p1_global=[];
p2_global=[];
p3_global=[];

p1_store=[];
p2_store=[];
p3_store=[];
legendInfo=[];

pitch_speed_use=0;


source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Select UAS typical propellers';
%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\heavily reduced';
source_dir='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\combined\2medium';
A=dir(source_dir);



for k=1:17%17=0.8
    step=0.05;
    around=0.0+(k-1)*step

    lower_bound=around-step/2+0.0001%0.5
    upper_bound=around+step/2%0.8
    lower_diam=0%10
    upper_diam=99%22
    input3='x';%apcsf_';



    

    J_all=[];
    Ct_all=[];
    Cp_all=[];
    eta_all=[];



    used=0;
    J_all=[];
    for i=3:length(A)

        name=A(i).name;
        marker_1=0;
        marker_2=0;
        marker_3=0;

        for j=1:length(name)
            if(name(j)=='_')
                marker_1=j;
            elseif(name(j)=='x')
                marker_2=j;
            elseif(name(j)=='.' & name(j+1)=='x')
                marker_3=j;
                break;
            end
        end

        diam=str2num(name([marker_1+1:marker_2-1]));
        pitch=str2num(name([marker_2+1:marker_3-1]));
        p_D=pitch/diam;


        if(p_D>=lower_bound & p_D<=upper_bound & diam>=lower_diam & diam<=upper_diam & strfind(name,input3)>=1)
            name
            p_D

            filename=strcat(source_dir,'\',name);

            store=xlsread(filename);
            if(pitch_speed_use==1)
                J=store(:,1)/(p_D);
            else
                J=store(:,1);
            end;
            Ct=store(:,2);
            Cp=store(:,3);
            eta=store(:,4);


            

            J_all=[J_all;J];
            Ct_all=[Ct_all;Ct];


            Cp_all=[Cp_all;Cp];


            eta_all=[eta_all;eta];

            used=1;


        end


    end




    if(used==1)
        figure(1);
        p1=polyfit(J_all,Ct_all,3);
        p1_store=[p1_store;p1];
        x=linspace(min(J_all),max(J_all),100);
        y=polyval(p1,x);
        plot(x,y)
        legendInfo{end+1}=[strrep(num2str(around),'_',' ')];
        %legendInfo{counter}={num2str(around)};

        figure(2);
        p2=polyfit(J_all,Cp_all,3);
        p2_store=[p2_store;p2];
        plot(x,polyval(p2,x));


        for(i=1:100)

            J_all(end+1)=0;
            eta_all(end+1)=0;


        end

        figure(3);
        p3=polyfit(J_all,eta_all,6);
        p3_store=[p3_store;p3];
        x=linspace(0,max(J_all),100);
        plot(x,polyval(p3,x));

        figure(2);
        figure(1);
    end
    counter=counter+1

    
end

if(length(legendInfo)>=1)
    
    figure(1);
    legend(legendInfo);
    legend('Location','eastoutside')
    title('UIUC data (generalised)')
    if(pitch_speed_use==1)
        xlabel('J/(pitch/Diam)=Pitch Speed')
    else
        xlabel('J')
    end
    ylabel('C_t')
    grid on
    figure(2);
    legend(legendInfo)
    legend('Location','eastoutside')
    title('UIUC data (generalised)')
    if(pitch_speed_use==1)
        xlabel('J/(pitch/Diam)=Pitch Speed')
    else
        xlabel('J')
    end
    ylabel('C_p')
    grid on
    figure(3);
    legend(legendInfo)
    legend('Location','eastoutside')
    title('UIUC data (generalised)')
    if(pitch_speed_use==1)
        xlabel('J/(pitch/Diam)=Pitch Speed')
    else
        xlabel('J')
    end
    ylabel('eta')
    grid on
    figure(2)
    figure(1)
end
