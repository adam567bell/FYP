%combine any of the excel files which have the same starting name, so that
%all values are together
clear
clc

source_dir='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\convert individual to xlsx\';
A=dir(source_dir)

for i=3:length(A)
    filename=strcat(source_dir,A(i).name)
    e = actxserver ('Excel.Application');
    efile = e.Workbooks.Open(filename);
    sheets=efile.Worksheets.Count
    efile.Close
    
   	store=[0,0,0,0]
    for j=2:sheets
        if(j==2)
            store=xlsread(filename,j)
        else
            store=[store;xlsread(filename,j)]
        end
    end
    store
    saved_filename='C:\Users\Adam\Documents\University\2017\FYP\Data\UIUC-propDB\UIUC-propDB\volume-1\data\Combined\'
    saved_filename=strcat(saved_filename,A(i).name)
    xlswrite(saved_filename,store)
end