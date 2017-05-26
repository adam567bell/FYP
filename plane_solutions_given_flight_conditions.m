
clear
clc
close all

%max/min diameter and pitch (all in inches)
max_diam=99;
min_diam=0;
max_pitch=99;
min_pitch=0;

max_motor_weight=9999;
max_speed_rotation=9000;%RPM

if(max_diam<min_diam)
    disp('The minimum propeller DIAMETER is bigger than the maximum, please reverse the order')
    return;
end
if(max_pitch<min_pitch)
    disp('The minimum propeller PITCH is bigger than the maximum, please reverse the order')
    return;
end

%Use only purchasable props or use just make up imaginery props
only_available_props=1;
if(only_available_props~=0 & only_available_props~=1)
    disp('Please set the value for "only available props" to 0 to search theoretical props and set it to 1 to search only props which are purchaseable')
    return;
end

%Battery Iteration Bounds (Cell, will assume 3.7V/Cell)
max_cell_count=8;
min_cell_count=6;
step_cell_count=2;
if(max_cell_count<min_cell_count)
    disp('The minimum and maximum battery cell count are the wrong way around')
    return;
end

%cruise speed iteration bounds (m/s)
max_cruise_speed=27;
min_cruise_speed=24;
step_cruise_speed=3;
if(max_cruise_speed<min_cruise_speed)
    disp('The minimum and maximum cruise speed are the wrong way around')
    return;
end

%cruise thrust iteration bounds (Newtons)
max_cruise_thrust=13;
min_cruise_thrust=9;
step_cruise_thrust=4;
if(max_cruise_thrust<min_cruise_thrust)
    disp('The minimum and maximum cruise thrust are the wrong way around')
    return;
end

%mass iteration bounds (kg)
max_mass=9;
min_mass=9;
step_mass=1;
if(max_mass<min_mass)
    disp('The minimum and maximum mass are the wrong way around')
    return;
end

%ROC rates iteration bounds (m/s)
max_ROC=3;
min_ROC=3;
step_ROC=1;
if(max_ROC<min_ROC)
    disp('The minimum and maximum ROC are the wrong way around')
    return;
end

%ROC speed iteration bounds; This is the speed at which the aircraft is
%travelling under the maximum rate of climb
%if set to -1
max_ROC_speed=-1;
min_ROC_speed=-1;
step_ROC_speed=3;
if(max_ROC_speed<min_ROC_speed)
    disp('The minimum and maximum ROC forward velocity are the wrong way around')
    return;
end

%ROC Drag to account for the fact that flaps may be used at the maximum ROC
%if set to -1 then aircraft will be assumed to be in the same configuration
%as in cruise
max_ROC_drag=-1;
min_ROC_drag=-1;
step_ROC_drag=-1;
if(max_ROC_drag<min_ROC_drag)
    disp('The minimum and maximum ROC drag are the wrong way around')
    return;
end

local_directory=pwd;
%Load the coefficients for graphs
filename=strcat(local_directory,'\Ct_coefficients.xlsx');
Ct_load=xlsread(filename);
filename=strcat(local_directory,'\Cp_coefficients.xlsx');
Cp_load=xlsread(filename);
filename=strcat(local_directory,'\eta_coefficients.xlsx');
eta_load=xlsread(filename);



if(only_available_props==1)
    filename=strcat(local_directory,'\purchasable_propellers.xlsx');
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
    m=0;
    for i=min_diam:1:max_diam
        for j=min_pitch:1:max_pitch;
            m=m+1;
            avail_props_diam(m)=i;
            avail_props_pitch(m)=j;
        end
    end
    avail_props_diam=avail_props_diam';
    avail_props_pitch=avail_props_pitch';
end

%This will be the whole overall storage which gets presented to the user
store_total=zeros(8000000,41);


total_rows=1;
%This is the main body of the program which runs through the prop diam and
%pitch iteration for each of the below values
for cell_count=min_cell_count:step_cell_count:max_cell_count
    hell_world=1
    for cruise_speed=min_cruise_speed:step_cruise_speed:max_cruise_speed
        hello_world=2
        for cruise_thrust=min_cruise_thrust:step_cruise_thrust:max_cruise_thrust
            hellow_world=3
            for mass=min_mass:step_mass:max_mass
                for ROC=min_ROC:step_ROC:max_ROC
                    for ROC_speed=min_ROC_speed:step_ROC_speed:max_ROC_speed
                        for ROC_drag=min_ROC_drag:step_ROC_drag:max_ROC_drag
                    
                            %most of this is for matrix pre-allocation when
                            %there are a few million results
                            [store_local]=plane_management_function(Ct_load,Cp_load,eta_load,avail_props_diam,avail_props_pitch,cell_count,cruise_speed,cruise_thrust,mass,ROC,ROC_speed,ROC_drag,max_motor_weight,max_speed_rotation);
                            [a,b]=size(store_local);
                            store_total([total_rows:total_rows+a-1],[1:b])=store_local;
                            total_rows=total_rows+a;
                        end
                    end
                end
            end
        end
    end
end
hello_world=1
total_rows
logical=store_total(:,end)>0;
store_total=store_total(logical,:);



file_header={'cell count','cruise speed','cruise thrust','mass','ROC','ROC_velocity','Kv','Max Motor Power','Motor Weight','Rm','Io','Motor efficiency ROC','Motor efficiency cruise','Diam','Pitch','n_ROC','Q_ROC','Thrust_ROC','Power_ROC','I_ROC','V_ROC','I*V_ROC','Total Power ROC','n_max','torque max','thrust max','power max','velocity max','I max','V max','I*V_max','ESC_eff_ROC','ESC_eff_cruise','n_cruise','Q_cruise','Thrust_cruise','Power_cruise','I_cruise','V_cruise','I*V_cruise','Total Power cruise'};

% filename=strcat(local_directory,'\output_given_motor_find_propeller18.csv');
%  fid = fopen(filename, 'w') ;
%  fprintf(fid, '%s,', file_header{1,1:end-1}) ;
%  fprintf(fid, '%s\n', file_header{1,end}) ;
%  fclose(fid) ;
% 
%  dlmwrite(filename, store_total, '-append') ;
%  he_world=1
% if(total_rows<300000)
%     store_total=num2cell(store_total);
%     store_total=vertcat(file_header,store_total);
%     filename=strcat(local_directory,'\output_given_motor_find_propeller18.xlsx');
%     xlswrite(filename,store_total);
%     
% end

%need to sort through and find for each propeller the best value. E.G. if
%you are running a 10x13" propeller in the given flight conditions then
%just take the most efficient
store_min_power=zeros(1000000,b+1);
m=1;
random_old=store_total(1,1)*store_total(1,2)*store_total(1,3)*store_total(1,4)*store_total(1,5)*store_total(1,6)*store_total(1,14)*store_total(1,15);
lowest_power=999999;
best_i=0;
for i=1:total_rows-1
    random_current=store_total(i,1)*store_total(i,2)*store_total(i,3)*store_total(i,4)*store_total(i,5)*store_total(i,6)*store_total(i,14)*store_total(i,15);
    if(random_current==random_old)
        %still in the same flight conditions with the same propeller
        if(store_total(i,b)<lowest_power)
            best_i=i;
            lowest_power=store_total(i,b);
        end
    else
        %in new flight condition and need to save the best value from the
        %old one
        store_min_power(m,:)=[store_total(best_i,:),best_i];
        m=m+1;
        lowest_power=store_total(i,b);
        best_i=i;
        random_old=random_current;
    end
    
end

logical=store_min_power(:,1)>0;
store_min_power=store_min_power(logical,:);

condensed_min_power=store_min_power(:,[b,14,15,9,1,2,3,4,5,6,7,8,end]);
condensed_min_power=sortrows(condensed_min_power,1);


[prop_row,prop_column]=[7,2];
full_lookup_row=condensed_min_power(prop_row,end)




