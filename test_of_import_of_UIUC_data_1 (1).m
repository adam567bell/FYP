%load in a set of data from UIUC

clear
clc

%define folder name, currently locked variable of filename
foldername='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\';
filename=strcat(foldername,'apcsf_8x3.8_2779rd_5012.txt');
filename
M=readtable(filename,'Delimiter',' ')

A=table2array(M)
A=A(:,[1,4,7,10])

plot(A(:,1),A(:,4))


