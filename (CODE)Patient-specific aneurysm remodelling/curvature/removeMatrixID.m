%% Summary
%Author: Yifan Pu
%Last Update: August 2017
%input: element_centroid.dat under the local folder
%output: adjust the file structure to fit the special input demand of Tecplot, in order to finish the
%interpolation step  (I is the greatest divisor, J is the result)

%%
%Clear all variables, close all windows and clear command window 
clear 
close all
clc
%% read the element centroid data
IDelement_centroid=load('.\element_centroid.dat');
format long

%% deal with the data 
centroid=IDelement_centroid(:,2:4);

[t,~]=size(centroid);
a=t;
b=2:sqrt(a);
c=[];
while ~isempty(b)
    if mod(a,b(1))
        b(~mod(b,b(1)))=[];
        continue;
    else
        c=[c,b(1)];
        a=a/b(1);
        b(b>sqrt(a))=[];
    end
end

c=[c,a];
d=length(c);
J=c(d);
I=t/J;

%% write to file
fid=fopen('.\centroid_tecplot.dat','wt');
fprintf(fid,'%s%s%s%s%s%s\n','VARIABLES = ','"X"',',','"Y"',',','"Z"');
fprintf(fid,'%s%d%s%d%s\n','ZONE   I=',I,'   J=',J,'   K=1, F=POINT');
fprintf(fid,' %2.12f %2.12f %2.12f\n',centroid(:,1:3)');
fclose(fid);

%%
exit



