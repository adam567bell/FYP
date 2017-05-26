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

pitch_speed_use=0;
half_run=1;

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

max_eff_eff=[];
max_eff_J=[];
max_eff_Ct=[];
max_eff_Cp=[];
max_eff_p_D=[];




%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Select UAS typical propellers';
%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\heavily reduced';
source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Plane';

A=dir(source_dir);

not_1='zz';
not_2='zz';
not_3='zz';
not_4='zz';
not_5='zz';
not_6='zz';
not_7='zz';
not_8='zz';
not_9='zz';

max_run=21;
if(half_run==1)
    max_run=11;
end


for k=1:max_run%11
    step=0.05;
    if(half_run==0)
        around=0.0+(k-1)*step%*2
    elseif half_run==1
        around=0.0+(k-1)*step*2
    end

    lower_bound=around-step/2+0.0001%0.5
    upper_bound=around+step/2%0.8
    lower_diam=0%10
    upper_diam=99%22
    input3='x';%apcsf_';

    if(abs(around-0.35)<0.01 & step==0.05)
         not_1='rusp';
         not_2='zz';
         not_3='zz';
         not_4='grcp';
         not_5='ma_';
         not_6='zz';
         not_7='zz';
         not_8='zz';
         not_9='zz';
    end

    if(abs(around-0.45)<0.01 & step==0.05)
        not_1='kavfk_9x4';
        not_2='grcp_9x4';
        not_3='ma_9x4';
        not_4='magf_11x5';
        not_5='magf_9x4';
        not_6='grsn_9x4';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-0.50)<0.01 & step==0.05)
          not_1='zz';
          not_2='mas_10x5';
          not_3='zz';
          not_4='magf_8x4';
          not_5='zz';
          not_6='zz';
          not_7='zz';
          not_8='apce_11';
          not_9='zz';
    end
    
    if(abs(around-0.55)<0.01 & step==0.05)
        not_1='apc';
not_2='grc';
not_3='grsn_11';
not_4='gw';
not_5='ka';
not_6='magf_7';
not_7='mas';
not_8='ma_11';
not_9='grsn_9';
    end
    
    if(abs(around-0.60)<0.01 & step==0.05)
        not_1='gwsdd_10x6';
        not_2='grcsp_10x6';
        not_3='grcp';
        not_4='zz';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-0.65)<0.01 & step==0.05)
        not_1='zin_9x6';
        not_2='zin_11x7';
        not_3='ma_11x7';
        not_4='mas_11x7';
        not_5='mas_9x6';
        not_6='gwsdd_11x7';
        not_7='grcsp_9x6';
        not_8='mae';
        not_9='zz';
    end
    
    if(abs(around-0.70)<0.01 & step==0.05)
        not_1='mae_10x7';
        not_2='kyosho_10x7';
        not_3='mas_10x7';
        not_4='kavfk_11x.7.75';
        not_5='zz';%'apce_17x12';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-0.75)<0.01 & step==0.05)
        not_1='ma_11x8';
        not_2='acpsp_8x6';
        not_3='grsn_11x8';
        not_4='mas_11x8';
        not_5='apce_8x6';
        not_6='apcsp_8x6';
        not_7='grcp_11x8';
        not_8='apce_11x8';
        not_9='apcsp_11x8';
    end
    
    if(abs(around-0.80)<0.01 & step==0.05)
        not_1='mas_9x7';
        not_2='ma_11x9';
        not_3='magf_9x7';
        not_4='zz';
        not_5='grcsp_';
        not_6='grsn_';
        not_7='grcp_';
        not_8='kyosho';
        not_9='apcsp_11';
    end
    
    if(abs(around-0.85)<0.01 & step==0.05)
        not_1='apcsp_7x6';
        not_2='zz';
        not_3='zz';
        not_4='zz';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-0.90)<0.01 & step==0.05)
        not_1='apcsp_9x8';
        not_2='grsn_11x10';
        not_3='zz';
        not_4='zz';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-0.95)<0.01 & step==0.05)
        not_1='zz';
        not_2='zz';
        not_3='zz';
        not_4='zz';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-1.00)<0.01 & step==0.05)
        not_1='apcsp_10x10';
        not_2='apcsp_9x9';%apcsp_8x8
        not_3='apcsp_8x8';
        not_4='apce_8x8';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    
    if(abs(around-1.10)<0.01 & step==0.05)
        not_1='apccf_7.4x8.25';
        not_2='zz';
        not_3='zz';
        not_4='zz';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';
    end
    

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
            
            if(strfind(name,not_1)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_2)>=0  )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_3)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_4)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_5)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_6)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_7)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_8)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            if(strfind(name,not_9)>=0 )

                fprintf('Excluded: %s \n\n',name)
                continue;
            end
            name;
            p_D;

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
        p1=polyfit(J_all,Ct_all,2);%3
        p1_store=[p1_store;p1];
        x=linspace(min(J_all),max(J_all),100);
        y=polyval(p1,x);
        plot(x,y)
        legendInfo{end+1}=[strrep(num2str(around),'_',' ')];
        %legendInfo{counter}={num2str(around)};

        figure(2);
        p2=polyfit(J_all,Cp_all,2);%3
        p2_store=[p2_store;p2];
        plot(x,polyval(p2,x));

        

        for(i=1:100)

            J_all(end+1)=0;
            eta_all(end+1)=0;


        end

        figure(3);
        p3=polyfit(J_all,eta_all,5);
        p3_store=[p3_store;p3];
        x=linspace(0,max(J_all),100);
        plot(x,polyval(p3,x));
        
        
        logical=polyval(p3,x)==max(polyval(p3,x));
        y=polyval(p3,x);
        max_eff_eff(end+1)=y(logical);
        y=x;
        max_eff_J(end+1)=y(logical);
        y=polyval(p2,x);
        max_eff_Cp(end+1)=y(logical);
        y=polyval(p1,x);
        max_eff_Ct(end+1)=y(logical);
        max_eff_p_D(end+1)=around;
        
        
        
        
        
        figure(2);
        figure(1);
    end
    counter=counter+1;

    
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
figure(1)
output='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\graphs for all data/Ct all'
saveas(gcf,output,'jpeg')
figure(2)
output='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\graphs for all data/Cp all'
saveas(gcf,output,'jpeg')
figure(3)
output='C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\graphs for all data/eta all'
saveas(gcf,output,'jpeg')

%figure(4)
p4=polyfit(max_eff_J,max_eff_eff,2);
x=linspace(0,0.75,100);
y=polyval(p4,x);
%plot(x,y,'r','LineWidth',2)
