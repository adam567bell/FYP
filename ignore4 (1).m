foldername='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\';
%concatenate to add the specific file of interest
filename=strcat(foldername,'apcsf_8x3.8_2778rd_4007.txt')

%import in with delimiter on space as per typical format
M=readtable(filename,'Delimiter',' ');

%convert the imported table to an array
A=table2array(M);
[a,b]=size(M);

%this is for some files on static thrust which may potentially not have
%efficiency
if(b>=10)
    %A=A(:,[1,4,7,10]);
    J=A(:,1);
    Ct=A(:,4);
    Cp=A(:,7);
    eta=A(:,10);
elseif(b>=7)
    J=A(:,1);
    Ct=A(:,4);
    Cp=A(:,7);
    eta=zeros(size(J));
end
    %A=A(:,[1,4,7,10]);
    