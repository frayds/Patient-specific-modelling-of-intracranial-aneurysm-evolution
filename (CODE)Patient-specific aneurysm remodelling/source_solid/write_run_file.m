%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%% 
clc
clear
step_number=load('.\step_file.txt');
if step_number==1
    exit
end
fid2=fopen(sprintf('run%d.inp',step_number),'w');
fid=fopen('run1.inp','rt');
while ~feof(fid)
    aline=fgetl(fid);
    if isempty(aline)
             break
    else
       fprintf(fid2,'%s\n',aline);
    end    
end
for i=2:step_number
    fprintf(fid2,'\n');
    fprintf(fid2,'TIME,%d\n',i);
    fprintf(fid2,'TBDELE,AHYPE, ALL\n');
    fprintf(fid2,'/input, ''matHGO%d'',''inp''\n',i);
    fprintf(fid2,'NSUBST,10,100,10\n');
    fprintf(fid2,'ALLSEL\n');
    fprintf(fid2,'SOLVE\n');
    fprintf(fid2,'SAVE\n');
    fprintf(fid2,'/input, ''output_deformed%d'',''inp''\n',i);
    fprintf(fid2,'\n');
    fprintf(fid2,'\n');
end

% write the stress file
fprintf(fid2,'\n');
fprintf(fid2,'/post1\n');
fprintf(fid2,'*create,outctrl,txt\n');
fprintf(fid2,'/output,stress_element%d,dat\n',i);
fprintf(fid2,'PRESOL,S,PRIN\n');
fprintf(fid2,'/output\n');
fprintf(fid2,'*end\n');
fprintf(fid2,'/input,outctrl,txt\n');


fprintf(fid2,"SAVE,'structural_model%d','db'",i);



fclose(fid);
fclose(fid2);


%%

exit

