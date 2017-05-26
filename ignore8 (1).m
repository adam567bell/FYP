clear
clc

%can I export to excel into multiple sheets?

name_start='';
A=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data')
warning('off')
store=zeros(0,0)
for i=91:length(A)
    
    hit=string(A(i).name);
    
    if strfind(hit,'geom') 
        name_start='';
    elseif(strfind(hit,'static'))
        continue;
    else
        fprintf('%s\n',hit);
        
        %find the name up to the second underscore and find the speed
        
        counter=0;
        for j=1:length(hit)
            if(hit(j)=='_')
                counter=counter+1;
                if(counter==2)
                    prop_name=hit(1:j-1);

                elseif(counter==3)
                    speed=num2str(hit(j+1:end-4));

                    break;
                end


            end
        end
        A(i).name(1:j-7)
        A(i+1).name(1:j-7)
        
        if(A(i+1).name(1:j-7))==A(i).name(1:j-7)
            [J,Ct,Cp,eta]=UIUC_lookup(hit);
            
            store=[store;J,Ct,Cp,eta]
            
            
        else
            [J,Ct,Cp,eta]=UIUC_lookup(hit);
            store=[store;J,Ct,Cp,eta]
            filename=strcat(prop_name,'.xlsx');
            xlswrite(filename,store);
            store=[];
            name_start=A(i+1).name(1:j-7);
        end
            
            
    end
    
end
