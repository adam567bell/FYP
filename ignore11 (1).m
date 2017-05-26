%plot all (maybe just some) of the classes which have 10x5 in their name

%search through name list, find hits for the given input (make it multiple
%inputs)



%note to self, need to change the directory to a new folder which only has
%sensible props and none of the stupidly blunt ones which we won't run!
%

%look at if two props produce the same thrust (roughly) for different
%power, just throw one prop out and note that it was thrown out!!

%could have a 'power' prop setting, for the same p/d, (roughly same
%efficiency) but more thrust and more power use
%classify each prop as
%low power
%medium power
%high power
%shit (same thrust for more power use)


%%%%%%%%%now add it to the last matlab file, so that it filters out the relevant
%ones? or I should do name changes in the clone of the database and then
%filter out based on the name!

clear
clc
close all

around=1;
by=0.05;

not_1='zz';
not_2='zz';
not_3='zz';
not_4='zz';
not_5='zz';
not_6='zz';
not_7='zz';
not_8='zz';
not_9='zz';

 not_1='apcsp_10x10';
         not_2='apcsp_9x9';%apcsp_8x8
%         not_3='apcsp_8x8';
%         not_4='apce_8x8';
        not_5='zz';
        not_6='zz';
        not_7='zz';
        not_8='zz';
        not_9='zz';



lower_bound=around-by/2+0.0001
upper_bound=around+by/2

% % % % 
% % % % if(around==0.25 & by==0.05)
% % % %     %apcsp_11x3, medium power range?
% % % %     
% % % % end
% % % % if(around==0.30 & by==0.05)
% % % %     %apcsp_10x3, medium power range?
% % % %     
% % % % end
% % % % if(around==0.35 & by==0.05)
% % % %     %apcsf_11x3.8, high power
% % % %     %apcsp_11x4, shit as it behaves differently to everything else, peak is
% % % %                 %at a higher J value, and it's no better
% % % %     %grcp_11x4, shit
% % % %     %ma_11x4, shit
% % % %     %magf_11x4, medium power
% % % %     %rusp_11x4, shit, uses more power than magf_11x4
% % % %     
% % % %     not_1='ma_11x4';
% % % %     not_2='grcp_11x4';
% % % %     not_3='apcsp_11x4';
% % % %     not_4='rusp_11x4';
% % % %     not_5='zz';
% % % %     
% % % % end
% % % % if(around==0.40 & by==0.05)
% % % %     %apcsf_9x3.8, slight more thrust, slightly more power, earlier J peak
% % % %     %apcsp_9x4, slightly less thrust, a bit less power, later J peak
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % 
% % % % if(around==0.45 & by==0.05)
% % % %     %apc29ff_9x4, medium thrust
% % % %     %apcsf_10x4.7, high thrust
% % % %     %apcsf_11x4.7, high thrust
% % % %     %apcsf_8x3.8, high thrust
% % % %     %apcsp_11x5. medium thrust
% % % %     %grcp_9x4, low thrust
% % % %     %grsn_9x4, low thrust
% % % %     %gwssf_10x4.7, high thrust
% % % %     %gwssf_11x4.7, low thrust
% % % %     %kavfk_9x4, low thrust
% % % %     %ma_9x4, low thrust
% % % %     %magf_11x5, unsure
% % % %     %magf_9x4, low thrust
% % % %     
% % % %     not_1='ma';
% % % %     not_2='kav';
% % % %     not_3='gr';
% % % % %     not_4='apcsf_11x4.7';
% % % %     not_5='apc29ff_9x4';
% % % % %     not_6='apcsp_11x5';
% % % %     not_7='gwssf_11x4.7';
% % % % %     not_8='zz';
% % % % %     not_9='zz';
% % % % end
% % % % if(around==0.50 & by==0.05)
% % % %     %apce_10x5, high thrust
% % % %     %apce_11x5.5, middle thrust
% % % %     %apce_8x4, middle thrust
% % % %     %apce_9x4.5, shit
% % % %     %apcsf_9x4.7, shit
% % % %     %apcsp_10x5, high thrust
% % % %     %apcsp_8x4, middle thrust
% % % %     %gwssf_9x4.7, shit
% % % %     %magf_8x4, middle thrust
% % % %     %mas_10x5, shit
% % % %     
% % % %     not_1='mas';
% % % %     not_2='gwssf';
% % % %     not_3='apcsf_9x4.7';
% % % %     not_4='apce_9x4.5';
% % % %     not_5='magf_8x4';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % 
% % % % if(around==0.55 & by==0.05)
% % % %     %apc29ff_9x5, high thrust
% % % %     %apcsp_11x6, high thrust
% % % %     %grcp_11x6, low thrust
% % % %     %grcsp_9x5, medium thrust
% % % %     %grsn_11x6, medium thrust
% % % %     %grsn_9x5, high thrust
% % % %     %gwsdd_9x5, medium thrust
% % % %     %gwssf_8x4.3, medium thrust
% % % %     %kavfk_11x6, shit
% % % %     %ma_11x6, low thrust
% % % %     %magf_7x4, low thrust
% % % %     %magf_9x5, high thrust
% % % %     %mas_11x6, low thrust
% % % %     %mas_9x5, low thrust
% % % %     
% % % %     not_1='apcsp_11x6';
% % % %     not_2='apc29ff_9x5';
% % % %     not_3='grsn_9x5';
% % % %     not_4='mas';
% % % %     not_5='magf_7x4';
% % % %     not_6='grcp_11x6';
% % % %     not_7='kavfk_11x6';
% % % %     not_8='ma_11x6';
% % % %     not_9='magf_9x5';
% % % % end
% % % % if(around==0.60 & by==0.05)
% % % %     %apcsp_10x6, high thrust
% % % %     %grcp_10x6, medium thrust
% % % %     %grcsp_10x6, high thrust
% % % %     %grsn_10x6, medium thrust
% % % %     %gwsdd_10x6, low thrust
% % % %     %kyosho_10x6, high thrust
% % % %     %magf_10x6, medium thrust
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.65 & by==0.05)
% % % %     %apce_11x7, medium thrust
% % % %     %apce_19x12, medium thrust
% % % %     %apce_9x6, medium thrust
% % % %     %apcsf_11x7, high thrust
% % % %     %apcsf_9x6, high thrust
% % % %     %apcsp_11x7, medium thrust
% % % %     %apcsp_9x6, medium thrust
% % % %     %grcp_9x6, medium thrust
% % % %     %grcsp_9x6, high thrust
% % % %     %grsn_11x7, medium thrust
% % % %     %grsn_9x6, medium thrust
% % % %     %gwsdd_11x7, shit
% % % %     %kavfk_9x6, medium thrust
% % % %     %kyosho_11x7, shit
% % % %     %kyosho_9x6, shit
% % % %     %ma_11x7, shit
% % % %     %ma_9x6, medium thrust
% % % %     %mae_11x7, shit
% % % %     %mae_9x6,shit
% % % %     %mas_11x7, shit
% % % %     %mas_9x6,shit
% % % %     %zin_11x7, shit
% % % %     %zin_9x6, shit
% % % %     
% % % %     
% % % %     not_1='mas';
% % % %     not_2='mae';
% % % %     not_3='zin';
% % % %     not_4='ma_11x7';
% % % %     not_5='grcsp_9x6';
% % % %     not_6='apcsf';
% % % %     not_7='gwsdd_11x7';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.70 & by==0.05)
% % % %     %ance_8.5x6, medium thrust
% % % %     %apce_10x7, medium thrust
% % % %     %apce_17x12, medium thrust
% % % %     %apcsf_10x7, high thrust
% % % %     %apcsp_10x7, shit
% % % %     %grsn_10x7, medium
% % % %     %kavfk_11x7.75, shit
% % % %     %kyosho_10x7, high thrust
% % % %     %mae_10x7, high thrust
% % % %     %mas_10x7, shit
% % % %     
% % % %     not_1='apcsf_10x7';
% % % %     not_2='mae_10x7';
% % % %     not_3='kyosho_10x7';
% % % %     not_4='kavfk_11x7';
% % % %     not_5='mas_10x7';
% % % %     not_6='apcsp_10x7';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.75 & by==0.05)
% % % %     %apccf_7.8x6, shit
% % % %     %apce_11x8.5, medium thrust
% % % %     %apce_11x8, medium thrust
% % % %     %apce_8x6, high thrust
% % % %     %apcsf_8x6, high thrust
% % % %     %apcsp_11x8, shit
% % % %     %apcsp_8x6, shit
% % % %     %grcp_11x8, medium thrust
% % % %     %grsn_11x8, shit
% % % %     %gwssf_11x8, shit
% % % %     %gwssf_8x4, shit
% % % %     %ma_11x8, shit
% % % %     %magf_11x8, medium thrust
% % % %     %mas_11x8, low thrust
% % % %     
% % % %     not_1='apcsf_8x6';
% % % %     not_2='apce_8x6';
% % % %     not_3='apcsp_8x6';
% % % %     not_4='apcsp_11x8';
% % % %     not_5='apccf_7.8x6';
% % % %     not_6='mas_11x8';
% % % %     not_7='gw';
% % % %     not_8='grsn_11x8';
% % % %     not_9='ma_11x8';
% % % % end
% % % % if(around==0.80 & by==0.05)
% % % %     %ance_8.5x7, medium thrust
% % % %     %apcsp_10x8, high thrust
% % % %     %apcsp_11x9, high thrust
% % % %     %apcsp_9x7, medium thrust
% % % %     %grcp_10x8, low thrust
% % % %     %grcsp_10x8, high thrust
% % % %     %grsn_9x7, high thrust
% % % %     %gwssf_10x8, shit
% % % %     %gwssf_9x7, shit
% % % %     %kyosho_11x9, high thrust
% % % %     %ma_11x9, shit
% % % %     %magf_10x8, medium thrust
% % % %     %magf_9x7, medium thrust
% % % %     %mas_9x7, shit
% % % %     
% % % %     not_1='mas_9x7';
% % % %     not_2='gr';
% % % %     not_3='gw';
% % % %     not_4='kyosho';
% % % %     not_5='apcsp_11x9';
% % % %     not_6='ma_11x9';
% % % %     not_7='apcsp_10x8';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.85 & by==0.05)
% % % %     %apce_14x12, low thrust
% % % %     %apce_9x7.5, medium thrust
% % % %     %apcsf_9x7.5, high thrust
% % % %     %apcsp_7x6, shit
% % % %     
% % % %     not_1='apcsp_7x6';
% % % %     not_2='apcsf_9x7.5';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.90 & by==0.05)
% % % %     %apccf_7.8x7, medium thrust
% % % %     %apce_11x10, medium thrust
% % % %     %apcsp_10x9, medium thrust
% % % %     %apcsp_9x8, shit
% % % %     %grsn_11x10, medium thrust
% % % %     %ma_11x10, medium thrust
% % % %     %ma_9x8, medium thrust
% % % %     
% % % %     not_1='apcsp_9x8';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==0.95 & by==0.05)
% % % %     %apcsp_14x13
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==1.00 & by==0.05)
% % % %     %apce_8x8, high thrust
% % % %     %apce_9x9, medium thrust
% % % %     %apcsp_10x10, shit
% % % %     %apcsp_8x8, medium thrust
% % % %     %apcsp_9x9, medium thrust
% % % %     
% % % %     not_1='apcsp_10x10';
% % % %     not_2='apce_8x8';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==1.10 & by==0.05)
% % % %     %apccf_7.4x8.25, medium thrust
% % % %     %apcsp_9x10, medium thrust
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==1.25 & by==0.05)
% % % %     %apcsp_8x10
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end
% % % % if(around==1.30 & by==0.05)
% % % %     %apcsp_7x9
% % % %     
% % % %     not_1='zz';
% % % %     not_2='zz';
% % % %     not_3='zz';
% % % %     not_4='zz';
% % % %     not_5='zz';
% % % %     not_6='zz';
% % % %     not_7='zz';
% % % %     not_8='zz';
% % % %     not_9='zz';
% % % % end

%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Plane';
%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
%source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Select UAS typical propellers';
A=dir(source_dir);

%Ct=figure;
%Cp=figure;
%eta=figure;

J_all=[];
Ct_all=[];
Cp_all=[];
eta_all=[];

%figure(1)
%figure(2)
%figure(3)
figure;
counter=1;
counterer=0;

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
    
        
    if(p_D>lower_bound & p_D<upper_bound)
        
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
        counterer=counterer+1
        point_type='o';
        if(counterer<=7)
            point_type='o';
        elseif (counterer<=14)
            point_type='+';
        elseif(counterer<=21)
            point_type='*';
        elseif(counterer<=28)
            point_type='s';
        end
        
        filename=strcat(source_dir,'\',name);
        
        store=xlsread(filename);
        J=store(:,1);
        Ct=store(:,2);
        Cp=store(:,3);
        eta=store(:,4);
        
        %figure(1)
        
        subplot(2,2,4)
        hold on
        scatter(J,Ct,point_type)
        legendInfo{counter}=[strrep(name([1:end-5]),'_',' ')];
        counter=counter+1;
       
        
        
        
        subplot(2,2,2)
        hold on
        scatter(J,Cp,point_type,'DisplayName',name([1:end-5]))
        %legend('show')
        
        
        subplot(2,2,3)
        hold on
        scatter(J,eta,point_type,'DisplayName',name([1:end-5]))
        %legend('show')
        
        subplot(2,2,1)
        hold on
        scatter(J,eta,point_type,'DisplayName',name([1:end-5]))
        %legend('show')
        
        
        
        J_all=[J_all;J];
        Ct_all=[Ct_all;Ct];
        Cp_all=[Cp_all;Cp];
        eta_all=[eta_all;eta];
        
        
        
        
    end
    
    
end
subplot(2,2,4);


title('Ct')
subplot(2,2,2);
%legend(legendInfo)
%legend('Location','eastoutside')
title('Cp')
subplot(2,2,3);

title('eta')
subplot(2,2,1);
title('eta ')
legend(legendInfo)
legend('Location','eastoutside')


subplot(2,2,4)
p1=polyfit(J_all,Ct_all,4);
x=linspace(0,max(J_all),100);
y=polyval(p1,x);
plot(x,y,'r-')

subplot(2,2,2)
p2=polyfit(J_all,Cp_all,3);
plot(x,polyval(p2,x),'r-');

subplot(2,2,3)
for i=1:200
    J_all(end+1)=0;
    eta_all(end+1)=0;
end
p3=polyfit(J_all,eta_all,6);
plot(x,polyval(p3,x),'r-');
subplot(2,2,1)
plot(x,polyval(p3,x),'r-');