function [UIUC]=diameter_lookup(diameter)
    names=zeros(1,70);
    A=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data')
    warning('off')
    count=1;
    for i=3:length(A)
        if(strfind(A(i).name,strcat(num2str(diameter))))
            h=names;
            h1=string(A(i).name);
            names(1);
            hit=string(A(i).name);
            fprintf('%s\n',hit);
            count=count+1;
            
        end
    end
    

end