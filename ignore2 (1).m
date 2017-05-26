clear
clc

props=dir('C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data')
[a,b]=size(props);

props(3).name;

class=zeros(size(props));
counter=1;

for i=1:a
    k=findstr('apcsf',props(i).name);
    if(k==1)
        class(counter)=(props(i).name);
        counter=counter+1;
    end
        
end



break;
[a,b]=size(props)


for i=1:a
    k=findstr('apcsf',props(i,:));
    if(k==1)
    else
        props(i,1)='.';
    end
               
end

included=(props(:,1)~='.');

props(included,:)


