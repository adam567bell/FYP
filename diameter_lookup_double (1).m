function [UIUC]=diameter_lookup_double(diameter,other)
    names=zeros(1,70);
    A=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data')
    warning('off')
    count=1;
    for i=3:length(A)
        if(strfind(A(i).name,num2str(diameter)) && (strfind(A(i).name,strcat(num2str(other)))))
            h=names;
            h1=string(A(i).name);
            names(1);
            hit=string(A(i).name);
            fprintf('%s\n',hit);
            count=count+1;
            
        end
    end
    

end