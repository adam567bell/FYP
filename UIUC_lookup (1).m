function [J,Ct,Cp,eta]=UIUC_lookup(filename)

%folder directory currently
foldername='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\';
%concatenate to add the specific file of interest
filename=strcat(foldername,filename);

%import in with delimiter on space as per typical format
A=importdata(filename,' ',1);
A=A.data;


[a,b]=size(A);

%this is for some files on static thrust which may potentially not have
%efficiency
if(b>=4)
    %A=A(:,[1,4,7,10]);
    restriction=(A(:,4)>=0);
    J=A(:,1);
    J=J(restriction);
    Ct=A(:,2);
    Ct=Ct(restriction);
    Cp=A(:,3);
    Cp=Cp(restriction);
    eta=A(:,4);
    eta=eta(restriction);
elseif(b>=3)
    J=A(:,1);
    Ct=A(:,2);
    Cp=A(:,3);
    eta=zeros(size(J));
end
    %A=A(:,[1,4,7,10]);
    
end
