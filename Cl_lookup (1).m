function [Cl,Cd]=Cl_lookup(alpha_deg,Re,naca4412_50000,naca4412_100000,naca4412_200000);

%naca4412_100000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_100000.xlsx');

%naca4412_50000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_50000.xlsx');

%naca4412_200000=xlsread('C:\Users\Adam\Documents\University\2017\FYP\Code\filtering of propellers\naca4412_200000.xlsx');

row_100000=-999;
row_50000=-999;
row_200000=-999;
alpha_deg_round=round(4*alpha_deg,0)/4;

[a,b]=size(naca4412_100000);

row=-1;
for i=1:a
    if(naca4412_100000(i,1)==alpha_deg_round)
        row=i;
        row_100000=i;
        break;
    end
end
if(row==-1)
    Cl=-999;
    Cd=-999;
    return;
end
cl_100000=naca4412_100000(row,2);
cd_100000=naca4412_100000(row,3);


[a,b]=size(naca4412_50000);

row=-1;
for i=1:a
    if(naca4412_50000(i,1)==alpha_deg_round)
        row=i;
        row_50000=i;
        break;
    end
end
if(row==-1)
    Cl=-999;
    Cd=-999;
    return;
end

cl_50000=naca4412_50000(row,2);
cd_50000=naca4412_50000(row,3);

[a,b]=size(naca4412_200000);

row=-1;
for i=1:a
    if(naca4412_200000(i,1)==alpha_deg_round)
        row=i;
        row_200000=i;
        break;
    end
end
if(row==-1)
    Cl=-999;
    Cd=-999;
    return;
end

cl_200000=naca4412_200000(row,2);
cd_200000=naca4412_200000(row,3);
% 
% if(Re<50000)
%     Cl=cl_50000;
%     Cd=cd_50000;
% elseif(Re>200000)
%     Cl=cl_200000;
%     Cd=cd_200000;
% elseif(Re<100000)
%     Cl=(Re-50000)/50000*cl_100000+(1-(Re-50000)/50000)*cl_50000;
%     Cd=(Re-50000)/50000*cd_100000+(1-(Re-50000)/50000)*cd_50000;
% elseif(Re>=100000)
%     Re;
%     alpha_deg_round;
%     naca4412_200000;
%     Cl=(Re-100000)/100000*cl_200000+(1-(Re-100000)/100000)*cl_100000;
%     Cd=(Re-100000)/100000*cd_200000+(1-(Re-100000)/100000)*cd_100000;
% else
%     Cl=-999;
%     Cd=-999;
%     return
% end
% 
% 
% if(Re<=150000 & Re>=75000)
%     if(alpha_deg_round>alpha_deg)
%         upper_Cl=naca4412_100000(row_100000,2);
%         lower_Cl=naca4412_100000(row_100000-1,2);
%         upper_Cd=naca4412_100000(row_100000,3);
%         lower_Cd=naca4412_100000(row_100000-1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     elseif(alpha_deg_round<alpha_deg)
%         lower_Cl=naca4412_100000(row_100000,2);
%         upper_Cl=naca4412_100000(row_100000+1,2);
%         lower_Cd=naca4412_100000(row_100000,3);
%         upper_Cd=naca4412_100000(row_100000+1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     end
% end
% 
% 
% 
% 
% 
% 
% 
% if(Re<75000)
%     if(alpha_deg_round>alpha_deg)
%         upper_Cl=naca4412_50000(row_50000,2);
%         lower_Cl=naca4412_50000(row_50000-1,2);
%         upper_Cd=naca4412_50000(row_50000,3);
%         lower_Cd=naca4412_50000(row_50000-1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     elseif(alpha_deg_round<alpha_deg)
%         lower_Cl=naca4412_50000(row_50000,2);
%         upper_Cl=naca4412_50000(row_50000+1,2);
%         lower_Cd=naca4412_50000(row_50000,3);
%         upper_Cd=naca4412_50000(row_50000+1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     end
% end
% 
% 
% 
% 
% 
% if(Re>150000)
%     if(alpha_deg_round>alpha_deg)
%         upper_Cl=naca4412_200000(row_200000,2);
%         lower_Cl=naca4412_200000(row_200000-1,2);
%         upper_Cd=naca4412_200000(row_200000,3);
%         lower_Cd=naca4412_200000(row_200000-1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     elseif(alpha_deg_round<alpha_deg)
%         lower_Cl=naca4412_200000(row_200000,2);
%         upper_Cl=naca4412_200000(row_200000+1,2);
%         lower_Cd=naca4412_200000(row_200000,3);
%         upper_Cd=naca4412_200000(row_200000+1,3);
% 
%         gap_Cl=upper_Cl-lower_Cl;
%         gap_Cd=upper_Cd-lower_Cd;
% 
%         correction_Cl=(-alpha_deg+alpha_deg_round)/0.25*gap_Cl;
%         correction_Cd=(-alpha_deg+alpha_deg_round)/0.25*gap_Cd;
%         Cl=Cl-correction_Cl;
%         Cd=Cd-correction_Cd;
%     end
% end

Cl=cl_100000;
Cd=cd_100000;

end

%if outside range, return -999