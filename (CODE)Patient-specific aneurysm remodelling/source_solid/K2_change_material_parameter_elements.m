%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%% read the file
element_averageStress_Matix1=load('./element_averageStress_Matix1.dat');

element_averageStress_Matix2=load('./element_averageStress_Matix2.dat');

k_c_value=load('./k_c_value2.dat');

IDelement_centroid=load('.\element_centroid.dat');

[num,~]=size(IDelement_centroid);

%% artery c=1.5

line_artey=0;

element_Matrix_line_artery=[];


for i=1:num
    if(IDelement_centroid(i,4)<=line_artey)
        element_Matrix_line_artery=[element_Matrix_line_artery;IDelement_centroid(i,1)];
    end
end

%% parts below localized c=0.7

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


%% get the new k2 and the new c
[row,~]=size(element_averageStress_Matix1);


write_filePath='./K2_change_value.dat';
fid=fopen(write_filePath,'wt');

% always element_averageStress_Matix1 

collagen_growth_rate=0.8;
for i=1:row
    if(ismember(IDelement_centroid(i,1),element_Matrix_line_artery(:,1)))      
        new_element_averageStress_Matix(i,1)=1.5;
     else
        if(ismember(IDelement_centroid(i,1),element_Matrix_line_localize_below(:,1)))
            new_element_averageStress_Matix(i,1)=0.7;
        else
             if(ismember(IDelement_centroid(i,1),element_Matrix_aimArea(:,1)))
                 if(k_c_value(i,1)==0.7)
                     new_element_averageStress_Matix(i,1)=k_c_value(i,1)-0.28;
                 else
                     new_element_averageStress_Matix(i,1)=k_c_value(i,1)-0.14;
                 end
             else
                new_element_averageStress_Matix(i,1)=0.7;
             end            
        end 
    end
    
    new_element_averageStress_Matix(i,2)=...
         k_c_value(i,2)-...% original value of K2
            (...
                collagen_growth_rate*k_c_value(1,2)*...
                abs(element_averageStress_Matix2(i,2)-element_averageStress_Matix1(i,2))...%difference of first principal stress
                /abs(element_averageStress_Matix1(i,2)...
            ));
end

for i=1:row
    if(new_element_averageStress_Matix(i,2)<0)
        new_element_averageStress_Matix(i,2)=...
            (new_element_averageStress_Matix(i+1,2)+new_element_averageStress_Matix(i-1,2))/2;
    end
     fprintf(fid,'%f %f\n',new_element_averageStress_Matix(i,1),new_element_averageStress_Matix(i,2));
end

fclose(fid);

avg=mean(new_element_averageStress_Matix(:,2));

%%
exit;


