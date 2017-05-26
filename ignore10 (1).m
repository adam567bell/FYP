%plot all (maybe just some) of the classes which have 10x5 in their name

%search through name list, find hits for the given input (make it multiple
%inputs)



%note to self, need to change the directory to a new folder which only has
%sensible props and none of the stupidly blunt ones which we won't run!
%


clear
clc
close all

lower_bound=0.465
upper_bound=0.535



source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined';
A=dir(source_dir);

Ct=figure;
Cp=figure;
eta=figure;

J_all=[];
Ct_all=[];
Cp_all=[];
eta_all=[];

figure(1)
figure(2)
figure(3)

counter=1;

for i=1:length(A)
    
    name=A(i).name
    marker_1=0;
    marker_2=0;
    marker_3=0;

    for j=1:length(name)
        if(name(j)=='_')
            marker_1=j;
        elseif(name(j)=='x')
            marker_2=j;
        elseif(name(j)=='.')
            marker_3=j;
            break;
        end
    end
    
    diam=str2num(name([marker_1+1:marker_2-1]))
    pitch=str2num(name([marker_2+1:marker_3-1]))
    p_D=pitch/diam
    
        
    if(p_D>lower_bound & p_D<upper_bound)
        filename=strcat(source_dir,'\',name)
        
        store=xlsread(filename)
        J=store(:,1);
        Ct=store(:,2);
        Cp=store(:,3);
        eta=store(:,4);
        
        figure(1)
        hold on
        scatter(J,Ct)
        legendInfo{counter}=[strrep(name([1:end-5]),'_',' ')];
        counter=counter+1;
       
        J_all=[J_all;J];
        Ct_all=[Ct_all;Ct];
        
        figure(2)
        hold on
        scatter(J,Cp,'DisplayName',name([1:end-5]))
        legend('show')
        Cp_all=[Cp_all;Cp];
        
        figure(3)
        hold on
        scatter(J,eta,'DisplayName',name([1:end-5]))
        legend('show')
        eta_all=[eta_all;eta];
        
        
        
        
    end
    
    
end
figure(1);
legend(legendInfo);
legend('Location','eastoutside')
title('Ct')
figure(2);
legend(legendInfo)
legend('Location','eastoutside')
title('Cp')
figure(3);
legend(legendInfo)
legend('Location','eastoutside')
title('eta')



figure(1);
p1=polyfit(J_all,Ct_all,4);
x=linspace(0,max(J_all),100);
y=polyval(p1,x);
plot(x,y,'r-')

figure(2);
p2=polyfit(J_all,Cp_all,3);
plot(x,polyval(p2,x),'r-');

figure(3);
p3=polyfit(J_all,eta_all,6);
plot(x,polyval(p3,x),'r-');