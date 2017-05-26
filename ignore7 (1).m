clear
clc

%can I export to excel into multiple sheets?


A=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data')
warning('off')

for i=3:length(A)
    store=zeros(1,1);
    hit=string(A(i).name);
    
    if strfind(hit,'geom') 
        
    elseif(strfind(hit,'static'))
        
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
        
        
        [J,Ct,Cp,eta]=UIUC_lookup(hit);
        store=[J,Ct,Cp,eta]
        filename=strcat(prop_name,'.xlsx');
        xlswrite(filename,store,string(speed));
    end
    
end
