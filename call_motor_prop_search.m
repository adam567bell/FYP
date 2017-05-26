clear
clc
close all

max_diam=99;
min_diam=0;
max_pitch=99;
min_pitch=0;

only_available_props=1;


if(only_available_props==1)
    filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\purchasable_propellers.xlsx';
    avail_props=xlsread(filename);
    avail_props_diam=avail_props(:,1);
    avail_props_pitch=avail_props(:,2);

    logic=avail_props_diam<=max_diam;
    avail_props_diam=avail_props_diam(logic);
    avail_props_pitch=avail_props_pitch(logic);

    logic=avail_props_diam>=min_diam;
    avail_props_diam=avail_props_diam(logic);
    avail_props_pitch=avail_props_pitch(logic);

    logic=avail_props_pitch<=max_pitch;
    avail_props_diam=avail_props_diam(logic);
    avail_props_pitch=avail_props_pitch(logic);

    logic=avail_props_pitch>=min_pitch;
    avail_props_diam=avail_props_diam(logic);
    avail_props_pitch=avail_props_pitch(logic);
else
    max_diam=22;
    min_diam=14;
    max_pitch=22;
    min_pitch=8;
    m=0;
    for i=min_diam:1:max_diam
        for j=min_pitch:1:max_pitch;
            m=m+1;
            avail_props_diam(m)=i;
            avail_props_pitch(m)=j;
        end
    end
end

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\Ct_coefficients.xlsx';
Ct_load=xlsread(filename);

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\Cp_coefficients.xlsx';
Cp_load=xlsread(filename);

filename='C:\Users\Adam Bell\Documents\University\2017\FYP\Code\filtering of propellers\eta_coefficients.xlsx';
eta_load=xlsread(filename);



store=[];

for cell_count=6:2:12;
    for cruise_thrust=24:2:28;%newtons
        for ROC=3:4;%maximum thrust case
            for velocity_cruise=22:3:30;%m/s
                for mass=14:2:18;%kg



                    store1=motor_prop_search(Ct_load,Cp_load,eta_load,avail_props_diam,avail_props_pitch,cell_count,cruise_thrust,ROC,velocity_cruise,mass);
                    for(i=length(store1(:,1)):-1:1)
                        if(store1(i,1)~=0)
                            store1=store1([1:i],:);
                            store=[store;store1];
                            break;
                        end
                    end
                    a=cell_count
                    b=cruise_thrust
                end
            end
        end
    end
end


store=num2cell(store);
store=vertcat({'Cell Count','cruise thrust','ROC','velocity cruise','mass','Diam','Pitch','n_ROC','Q_ROC','Thrust_ROC','Power_ROC','I_ROC','V_ROC','I*V_ROC','Rm','Io','Max_motor_power','Kv','Weight','n_cruise','Q_cruise','Thrust_cruise','Power_cruise','I_cruise','V_cruise','I*V_cruise','Motor efficiency ROC','Motor efficiency cruise','esc eff ROC','esc eff cruise','total power ROC','total power cruise'},store);
xlswrite('C:\Users\Adam Bell\Documents\University\2017\FYP\Code\output_given_motor_find_propeller2.xlsx',store);
