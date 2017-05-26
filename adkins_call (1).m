%adkins call
clear
clc
close all

naca4412_100000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_100000.xlsx');

naca4412_50000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_50000.xlsx');

naca4412_200000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_200000.xlsx');


J_store=linspace(0.0,0.8,100);
for thrust=0.4:0.1:1.8
    for speed=18:18
        peak_reached=0;
        eta_store=[]
        for i=1:length(J_store)
            eta_store(i)=adkins(7,14,J_store(i),speed,thrust*9.81,[0.9,1,1.1,1.2,1,0.9,0.8,0.7,0.6,0.5],naca4412_50000,naca4412_100000,naca4412_200000);
            if(eta_store(i)<0 | eta_store(i)>1)
                eta_store(i)=0;
            end
%             if(i>1 & eta_store(i)<eta_store(i-1) & peak_reached==0)
%                 peak_reached=1;
%             end
%             if(i>1 & eta_store(i)>eta_store(i-1) & peak_reached==7)
%                 eta_store(i)=0;
%             end



        end

        eta_store
        scatter(J_store,eta_store)
        hold on
    end
    
end
%figure;
hold on

p3=[-10.8518,18.2726,-11.2047,1.3067,1.8762,0.0001];
plot(0:0.01:1,polyval(p3,0:0.01:1),'g')
grid on
