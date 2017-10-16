%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%% read the file
filePath='./stress_element.dat';
fid=fopen(filePath,'r');

j = 1;
while feof(fid) == 0    
    stress_element_dat_eachLine{j,1} = fgetl(fid);    
    j = j+1;
end

%% delete the useless lines
stress_element_dat_eachLine(1:3)=[];


%% get the characteristic line
temp=stress_element_dat_eachLine{1,1};

%% separate the date
[num,~]=size(stress_element_dat_eachLine);

column=0;
row=1;

for j=1:num
    if(isequal(stress_element_dat_eachLine{j,1},temp))
        column=column+1;
        row=1;
    end
    stress_element_CELL{row,column}=stress_element_dat_eachLine{j,1};
    row=row+1;
end

%% continue get the element and the average stress value
[row,column]=size(stress_element_CELL);

temp_cell_element_averageStress=cell(row,1);

row_element_averageStress_Matix=1;% make the dynamic growth matrix element_averageStress_Matix

for i=1:column
    for j=1:row
        temp_cell_element_averageStress{j,1}=stress_element_CELL{j,i};
    end
    
    for k=0:4
        row_temp_cell_element_averageStress=17+k*7;
        if(temp_cell_element_averageStress{row_temp_cell_element_averageStress,1})
            
            % get the number of element( the first row of element_averageStress_Matix)
            element_num_temp=char(temp_cell_element_averageStress{row_temp_cell_element_averageStress,1});
            S = regexp(element_num_temp, '\s+', 'split');
            element_num_temp=eval(S{1,3});
            
            element_averageStress_Matix(row_element_averageStress_Matix,1)=element_num_temp;
            
            % --get the value of average stress( the second row of element_averageStress_Matix)
            
            % the 1st S1 value
            S1_temp_1=char(temp_cell_element_averageStress{row_temp_cell_element_averageStress+2,1});
            S1_temp_1 = regexp(S1_temp_1, '\s+', 'split');
            S1_temp_1=str2num(S1_temp_1{1,3});
            format long;
            
            % the 2nd S1 value
            S1_temp_2=char(temp_cell_element_averageStress{row_temp_cell_element_averageStress+3,1});
            S1_temp_2 = regexp(S1_temp_2, '\s+', 'split');
            S1_temp_2=str2num(S1_temp_2{1,3});
            format long;

            % the 3rd S1 value
            S1_temp_3=char(temp_cell_element_averageStress{row_temp_cell_element_averageStress+4,1});
            S1_temp_3 = regexp(S1_temp_3, '\s+', 'split');
            S1_temp_3=str2num(S1_temp_3{1,3});
            format long;

            % the 4th S1 value
            S1_temp_4=char(temp_cell_element_averageStress{row_temp_cell_element_averageStress+5,1});
            S1_temp_4 = regexp(S1_temp_4, '\s+', 'split');
            S1_temp_4=str2num(S1_temp_4{1,3});
            format long;

            % the average S1 value
            S1_temp_average=(S1_temp_1+S1_temp_2+S1_temp_3+S1_temp_4)/4;
            
            element_averageStress_Matix(row_element_averageStress_Matix,2)=S1_temp_average;
            
            
            % grow the sign +1 ( row_element_averageStress_Matix)
            row_element_averageStress_Matix=row_element_averageStress_Matix+1;
        else
            break;
        end
    end
    
end

%% write element_averageStress_Matix---->the result file(element_averageStress_Matix.dat)
file_write_Path='./element_averageStress_Matix.dat';
fid=fopen(file_write_Path,'wt');

for i=1:element_num_temp
    fprintf(fid,'%d %.8f\n',element_averageStress_Matix(i,1),element_averageStress_Matix(i,2));
end

fclose(fid);

%%
exit;


