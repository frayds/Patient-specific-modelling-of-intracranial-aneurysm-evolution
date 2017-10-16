%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%%
%Clear all variables, close all windows and clear command window 
clear 
close all
clc

%% read the file
normlizeCentiod_first_prinCurvaDir_temp=load('.\normlizeCentiod_first_prinCurvaDir_temp.dat');


%read IDelement_centroid ID

IDelement_centroid=load('.\element_centroid.dat');

ID=IDelement_centroid(:,1);

normlizeCentiod_second_prinCurvaDir_temp=load('.\normlizeCentiod_second_prinCurvaDir_temp.dat');

k_c_value=load('.\k_c_value.dat');

[num,~]=size(IDelement_centroid);

%% artery c=1.5

line_artey=0;

element_Matrix_line_artery=[];


for i=1:num
    if(IDelement_centroid(i,4)<=line_artey)
        element_Matrix_line_artery=[element_Matrix_line_artery;IDelement_centroid(i,1)];
    end
end

%% parts below localized c=0.8

line_localize_below=2.1802188015;

element_Matrix_line_localize_below=[];

for i=1:num
    if((IDelement_centroid(i,4)<=line_localize_below) && (IDelement_centroid(i,4)>line_artey))
        element_Matrix_line_localize_below=[element_Matrix_line_localize_below;IDelement_centroid(i,1)];
    end
end

%% localize

localize_center_point=[1.95115,1.19478,5.59539];

longest_distance_point=[-1.74741,3.54609,2.84923];

LongestDistance=sqrt((localize_center_point(1,1)-longest_distance_point(1,1))^2+...
                        (localize_center_point(1,2)-longest_distance_point(1,2))^2+...
                        (localize_center_point(1,3)-longest_distance_point(1,3))^2);

element_Matrix_aimArea=[]; 

                    
               
for i=1:num
    if(IDelement_centroid(i,4)>line_localize_below)
        distance=sqrt((IDelement_centroid(i,2)-longest_distance_point(1,1))^2+...
                        (IDelement_centroid(i,3)-longest_distance_point(1,2))^2+...
                        (IDelement_centroid(i,4)-longest_distance_point(1,3))^2);
        if(distance<=LongestDistance)
            element_Matrix_aimArea=[element_Matrix_aimArea;IDelement_centroid(i,1)];
        end
    end
end

% localize_centroid=IDelement_centroid(22687,:);
% 
% line=6.520915;
% 
% 
% id=0;
% 
% new_centroid=[];
% row=0;
% 
% for i=1:num
%     if(IDelement_centroid(i,4)>line)
%         row=row+1;
%         new_centroid(row,:)=[...
%             IDelement_centroid(i,1),...
%             IDelement_centroid(i,2),...
%             IDelement_centroid(i,3),...
%             IDelement_centroid(i,4)...
%             ];
%     end
% end
% 
% 
% for i=1:row
%     new_centroid(i,5)=...
%         sqrt(...
%         (new_centroid(i,2)-localize_centroid(1,2))^2+...
%         (new_centroid(i,3)-localize_centroid(1,3))^2+...
%         (new_centroid(i,4)-localize_centroid(1,4))^2....
%             );
%     if(new_centroid(i,1)==18256)
%         id=i;
%     end
% end
% 
% die_er_ta=0.6/new_centroid(id,5);

%% write to matHGO.inp

k_bulk_modulus=34.7;

write_filePath='.\matHGO.inp';
write_filePath_fid=fopen(write_filePath,'wt');


for i=1:num
     if(ismember(IDelement_centroid(i,1),element_Matrix_line_artery(:,1)))
        fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
        fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',1.5);
        fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',40,40);
     else
        if(ismember(IDelement_centroid(i,1),element_Matrix_line_localize_below(:,1)))
            fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
            fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1));
            fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2));
        else
             if(ismember(IDelement_centroid(i,1),element_Matrix_aimArea(:,1)))
                fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
                if(k_c_value(i,1)>=0.7)
                    fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1)-0.14);%localize
                else
                    fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1));%localize
                end
                fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2));
             else
                fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
                fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1));
                fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2)); 
             end            
        end 
     end
%     if(ismember(IDelement_centroid(i,1),new_centroid(:,1)))
%         fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
%         for j=1:row
%             if(new_centroid(j,1)==IDelement_centroid(i,1))
%                 id=j;
%             end
%         end
%         fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1)-die_er_ta*new_centroid(id,5));
%         fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2));
%     else
%         fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
%         fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1));
%         fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2));
%     end
   
%      fprintf(write_filePath_fid,'TB,AHYPER,%d,,,EXPO\n',ID(i,1));
%      fprintf(write_filePath_fid,'TBDATA,1,%f,0,0,0,0,0\n',k_c_value(i,1));
%      fprintf(write_filePath_fid,'TBDATA,7,1.000000e-03,%f,1.000000e-03,%f\n',k_c_value(i,2),k_c_value(i,2));
    
       
    fprintf(write_filePath_fid,'\n');
    
    fprintf(write_filePath_fid,'TB,AHYPER,%d,,,PVOL\n',ID(i,1));
    fprintf(write_filePath_fid,'TBDATA,,%.8f\n',1/k_bulk_modulus);
    
    fprintf(write_filePath_fid,'\n');
    
    fprintf(write_filePath_fid,'TB,AHYPER,%d,,,AVEC\n',ID(i,1));
    fprintf(write_filePath_fid,'TBDATA,,   %.8f,    %.8f,    %.8f',...
        normlizeCentiod_first_prinCurvaDir_temp(i,1),normlizeCentiod_first_prinCurvaDir_temp(i,2),normlizeCentiod_first_prinCurvaDir_temp(i,3));
    
    fprintf(write_filePath_fid,'\n\n');
    
    fprintf(write_filePath_fid,'TB,AHYPER,%d,,,BVEC\n',ID(i,1));
    fprintf(write_filePath_fid,'TBDATA,,    %.8f,   %.8f,    %.8f',...
        normlizeCentiod_second_prinCurvaDir_temp(i,1),normlizeCentiod_second_prinCurvaDir_temp(i,2),normlizeCentiod_second_prinCurvaDir_temp(i,3));
    
    fprintf(write_filePath_fid,'\n');
    fprintf(write_filePath_fid,'\n\n');
end

disp('finish the writing progress');

fclose(write_filePath_fid);


%%
exit



