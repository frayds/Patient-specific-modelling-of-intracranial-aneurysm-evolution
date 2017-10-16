%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%%
%Clear all variables, close all windows and clear command window 
clear 
close all
clc

%% 

loopNum=2;


c_Array=[0.8 0.7];
k2_Array=[40 40];


IDelement_centroid=load('.\element_centroid.dat');

ID=IDelement_centroid(:,1);


[num,~]=size(ID);

for i=1:loopNum
    filePath=['k_c_value',num2str(i),'.dat'];
    fid=fopen(filePath,'wt');
    
    for j=1:num
        fprintf(fid,'%f %f\n',c_Array(1,i),k2_Array(1,i));
    end
    fclose(fid);
end



%%
exit




