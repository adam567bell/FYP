clear
clc
close all

A=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data');

[a,b]=size(A);

previous_name_full='';
previous_name_part='';

for i=3:a
    speed_pos=0;
    original_name=A(i).name
    counter=0;
    for j=1:length(original_name)
        if(original_name(j)=='_')
            counter=counter+1;
            if(counter==2)
                saved_name_part=original_name(1:j-1)
                
            elseif(counter==3)
                speed=num2str(original_name(j+1:end-4));
                
                break;
            end
       
            
        end
        
        
            
    
    end
    
    saved_name_part
    if(strcmp(saved_name_part,previous_name_part))
        number_previous=str2num(previous_name_full(end:end));
        number_current=number_previous+1;
        
        saved_name_full=strcat(saved_name_part,'_',num2str(number_current));
    else
        saved_name_full=strcat(saved_name_part,'_1');
    end
    previous_name_part=saved_name_part;
    previous_name_full=saved_name_full;
    
    [J,Ct,Cp,eta]=UIUC_lookup(original_name);
    
    
    UIUC.RPM=speed;
    UIUC.J=J;
    UIUC.Ct=Ct;
    UIUC.Cp=Cp;
    UIUC.eta=eta;
    
end