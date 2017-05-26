


clear
clc
close all

%naca4412
naca4412_100000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_100000.xlsx');
naca4412_50000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_50000.xlsx');
naca4412_200000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_200000.xlsx');

%clarky
%naca4412_100000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\clarky_100000.xlsx');
%naca4412_50000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\clarky_50000.xlsx');
%naca4412_200000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\clarky_200000.xlsx');


%J=0.463905
J=0.0:0.01:1;
%J=0.5:0.01:0.5;
Ct_store=[];
Cp_store=[];
eta_store=[];
for i=1:length(J)
    diam=14;
    diam=10;
    pitch=7;
    pitch=8;
    target_speed=18;
    %chord=[0.9,1,1.1,1.2,1,0.9,0.8,0.7,0.6,0.5];
    chord=[1,1,1,0.9,0.8,0.7,0.6,0.5,0.4,0.3];
    %t_max=[0.005,0.005,0.0045,0.004,0.004,0.0035,0.003,0.0025,0.002,0.0015];
    t_max=[0.004,0.004,0.004,0.0035,0.003,0.0025,0.002,0.0015,0.001,0.001];

    [Ct,Cp,eta]=mcVortex(pitch,diam,J(i),target_speed,t_max,chord,naca4412_50000,naca4412_100000,naca4412_200000);
    Ct_store(end+1)=Ct;
    Cp_store(end+1)=Cp;
    eta_store(end+1)=eta;
    

end


%filter from the first negative value or first value>1

ignore=0;
for i=1:length(eta_store)
    if(eta_store(i)<0 | eta_store(i)>1)
        ignore=1;
    end
    if(ignore==1)
        Ct_store(i)=0;
        Cp_store(i)=0;
        eta_store(i)=0;
    end
end

eta_store

figure;
subplot(2,2,1)
scatter(J,Ct_store)
grid on
subplot(2,2,2)
scatter(J,Cp_store)
grid on
subplot(2,2,3)
scatter(J,eta_store)
grid on
subplot(2,2,4)
scatter(J,eta_store)
grid on

for i=2:length(eta_store)
    if(eta_store(i)==0)
        break;
    end
end

Ct_store_useful=Ct_store(1:i);
Cp_store_useful=Cp_store(1:i);
eta_store_useful=eta_store(1:i);
J_useful=J(1:i);


p3=polyfit(J_useful,eta_store_useful,3);
subplot(2,2,3)
hold on
%plot(J_useful,polyval(p3,J_useful),'r')
grid on
subplot(2,2,4)
hold on
%plot(J_useful,polyval(p3,J_useful),'r')
grid on


max_Cp=max(Cp_store_useful);
for i=1:length(Cp_store_useful)
    if(Cp_store_useful(i)==max_Cp)
        break;
    end
end

Ct_store_useful=Ct_store_useful(i:end);
Cp_store_useful=Cp_store_useful(i:end);
eta_store_useful=eta_store_useful(i:end);
J_useful=J_useful(i:end);

p1=polyfit(J_useful,Ct_store_useful,2);
p2=polyfit(J_useful,Cp_store_useful,2);

subplot(2,2,1)
hold on
%plot(J_useful,polyval(p1,J_useful),'r')
grid on
subplot(2,2,2)
hold on
%plot(J_useful,polyval(p2,J_useful),'r')
grid on

p1=[-0.1406,-0.016,0.1211];
p2=[-0.1511,0.0918,0.05];
p3=[-10.8518,18.2726,-11.2047,1.3067,1.8762,0.0001];

subplot(2,2,1)
hold on
plot(0:0.01:1,polyval(p1,0:0.01:1),'g')
grid on
subplot(2,2,2)
hold on
plot(0:0.01:1,polyval(p2,0:0.01:1),'g')
grid on
subplot(2,2,3)
hold on
plot(0:0.01:1,polyval(p3,0:0.01:1),'g')
grid on
subplot(2,2,4)
hold on
plot(0:0.01:1,polyval(p3,0:0.01:1),'g')
grid on






