clear
clc
close all




plot_on_same=1;

figure;

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0535_3003.txt');
plot(J1,eta1,'r')
hold on

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0536_3998.txt');
plot(J1,eta1,'r')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0537_3995.txt');
plot(J1,eta1,'r')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0538_4997.txt');
plot(J1,eta1,'r')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0539_4997.txt');
plot(J1,eta1,'r')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0540_5988.txt');
plot(J1,eta1,'r')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x7_kt0541_6003.txt');
plot(J1,eta1,'r')

%legend('show')
if(plot_on_same==0)
    figure;
end


[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1079_1500.txt');
plot(J1,eta1,'k')
hold on

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1080_2096.txt');
plot(J1,eta1,'k')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1081_2502.txt');
plot(J1,eta1,'k')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1082_2508.txt');
plot(J1,eta1,'k')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1083_2991.txt');
plot(J1,eta1,'k')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_19x12_jb1084_3007.txt');
plot(J1,eta1,'k')

title('Ct vs J red is apce 11x7 black is apce 19x12')

%legend('show')
if(plot_on_same==0)
    figure;
end
break;
[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0821_5000.txt');
plot(J1,Ct1,'b')
hold on

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0822_4993.txt');
plot(J1,Ct1,'b')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0823_6005.txt');
plot(J1,Ct1,'b')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0824_6018.txt');
plot(J1,Ct1,'b')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0825_6707.txt');
plot(J1,Ct1,'b')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_kt0826_6710.txt');
plot(J1,Ct1,'b')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_pg0820_4005.txt');
plot(J1,Ct1,'b')

legend('show')
if(plot_on_same==0)
    figure;
end

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0468_3994.txt');
plot(J1,Ct1,'g')
hold on

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0469_4999.txt');
plot(J1,Ct1,'g')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0470_4998.txt');
plot(J1,Ct1,'g')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0471_6002.txt');
plot(J1,Ct1,'g')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0472_6000.txt');
plot(J1,Ct1,'g')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_11x5.5_kt0516_3010.txt');
plot(J1,Ct1,'g')

[J1,Ct1,Cp1,eta1]=UIUC_lookup('apce_10x5_pg0820_4005.txt');
plot(J1,Ct1,'g')

legend('show')



