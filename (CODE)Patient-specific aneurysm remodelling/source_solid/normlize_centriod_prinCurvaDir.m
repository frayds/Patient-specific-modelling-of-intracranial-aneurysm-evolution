%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%%
%Clear all variables, close all windows and clear command window 
clear 
close all
clc

%% read the file

%centroid_first_curvature_vector.dat load and norm-->norm_centroid_first_curvature_vector
fid_first = fopen('.\centroid_first_curvature_vector.dat','r');
tempCell_first= textscan(fid_first,'%f %f %f','HeaderLines',9);
fclose(fid_first);

centroid_first_curvature_vector=cell2mat(tempCell_first);

[m,n]=size(centroid_first_curvature_vector);
norm_centroid_first_curvature_vector=[];

for i=1:m
    temp=centroid_first_curvature_vector(i,:)/norm(centroid_first_curvature_vector(i,:));
    norm_centroid_first_curvature_vector=[norm_centroid_first_curvature_vector;temp];
end

write_normlizeCentiod_firstprinCurvaDir_filePath='./normlizeCentiod_first_prinCurvaDir_temp.dat';
fid_write=fopen(write_normlizeCentiod_firstprinCurvaDir_filePath,'wt');

for i=1:m
    fprintf(fid_write,'%f %f %f\n',norm_centroid_first_curvature_vector(i,1),...
        norm_centroid_first_curvature_vector(i,2),norm_centroid_first_curvature_vector(i,3));
end


%centroid_second_curvature_vector.dat load and norm-->norm_centroid_second_curvature_vector
fid_second = fopen('.\centroid_second_curvature_vector.dat','r');
tempCell_second= textscan(fid_second,'%f %f %f','HeaderLines',9);
fclose(fid_second);

centroid_second_curvature_vector=cell2mat(tempCell_second);

[m,n]=size(centroid_second_curvature_vector);
norm_centroid_second_curvature_vector=[];

for i=1:m
    temp=centroid_second_curvature_vector(i,:)/norm(centroid_second_curvature_vector(i,:));
    norm_centroid_second_curvature_vector=[norm_centroid_second_curvature_vector;temp];
end

write_normlizeCentiod_secondprinCurvaDir_filePath='./normlizeCentiod_second_prinCurvaDir_temp.dat';
fid_write=fopen(write_normlizeCentiod_secondprinCurvaDir_filePath,'wt');

for i=1:m
    fprintf(fid_write,'%f %f %f\n',norm_centroid_second_curvature_vector(i,1),...
        norm_centroid_second_curvature_vector(i,2),norm_centroid_second_curvature_vector(i,3));
end


%%
exit

