nfiles  = load('nfiles.txt');
step_number=load('step_file.txt');

    fid= fopen(sprintf('output_deformed%i.inp',step_number),'w');
    %output the nodes information attaching to the inner surface
    fprintf(fid,'ASEL,S,,,%d,%d,, \n',879,956);      
    fprintf(fid,'NSLA,S,1\n');
    fprintf(fid,'/output,nlist%d,txt,,append\n',step_number);
    fprintf(fid,'nlist\n');
    fprintf(fid,'/output\n'); 
    fprintf(fid,'/GO\n'); 
    fprintf(fid,'!*\n'); 
    fprintf(fid,'ASEL,S,,,%d,%d,, \n',973,1140);  
    fprintf(fid,'NSLA,S,1\n');
    fprintf(fid,'/output,nlist%d,txt,,append\n',step_number);
    fprintf(fid,'nlist\n');
    fprintf(fid,'/output\n'); 
    %output the displacement information on all nodes
	fprintf(fid,'ALLSEL\n'); 
    fprintf(fid,'*GET,Nnod,NODE,0,COUNT\n'); 
    fprintf(fid,'*DIM,S_Xyz,ARRAY,Nnod,8\n');  
    fprintf(fid,'*GET,Nd,NODE,0,NUM,MIN\n'); 
    fprintf(fid,'*get,n_max,NODE,0,NUM,Max\n'); 
    fprintf(fid,'*DO,I,1,Nnod,1\n'); 
    fprintf(fid,'S_Xyz(I,1)=Nd\n'); 
    fprintf(fid,'S_Xyz(I,2)=NX(Nd)\n'); 
    fprintf(fid,'S_Xyz(I,3)=NY(Nd)\n'); 
    fprintf(fid,'S_Xyz(I,4)=NZ(Nd)\n'); 
    fprintf(fid,'*GET,S_Xyz(I,5),NODE,Nd,U,X\n');
    fprintf(fid,'*GET,S_Xyz(I,6),NODE,Nd,U,Y\n'); 
    fprintf(fid,'*GET,S_Xyz(I,7),NODE,Nd,U,Z\n'); 
    fprintf(fid,'*GET,S_Xyz(I,8),NODE,Nd,U,SUM\n'); 
    fprintf(fid,'Nd=NDNEXT(Nd)\n'); 
    fprintf(fid,'*ENDDO\n'); 
    fprintf(fid,'*cfopen,deformcoordinner%d,txt\n',step_number); 
    fprintf(fid,'*vwrite, S_Xyz(1,1), S_Xyz(1,2), S_Xyz(1,3), S_Xyz(1,4),S_Xyz(1,5),S_Xyz(1,6),S_Xyz(1,7),S_Xyz(1,8)\n'); 
    fprintf(fid,'(F10.0,F12.8,F12.8,F12.8,F12.8,F12.8,F12.8,F12.8)\n');
    fprintf(fid,'*cfclos\n');
    
    
%%
    exit
    
    
    
    