#!/usr/bin/perl
    use strict;
    use warnings;
    use File::Copy;    # The File::Copy module exports two functions, copy and move
    use File::Find;	   # The File::Find module exports to find the file
    use File::Copy qw(move);
	
#------ Loop structure of Patient Specific aneurysm remodelling 
#------ Yifan Pu @ Sheffield   09/08/2017

#--  delete files from previous simulation--------------------------------------

foreach my $file (glob "*.inp")     # delete all input files    
{
   unlink $file or print "unable to delete $file\n";    # unlink: remove files
}

foreach my $filetxt (glob "*.txt")     # delete all txt files
{
   unlink $filetxt or print "unable to delete $filetxt\n";
}

foreach my $filedat (glob "*.dat")     # delete all dat files
{
   unlink $filedat or print "unable to delete $filedat\n";
}

foreach my $fileout (glob "*.out")     # delete all dat files
{
   unlink $fileout or print "unable to delete $fileout\n";
}
   
foreach my $fileout (glob "*.m")     # delete all dat files
{
   unlink $fileout or print "unable to delete $fileout\n";
}	
# -------------  type in nfiles ------------------------------------------------
# giving time step  nfiles-1

my $nfiles = 4;                # type in nfiles here! this is the loop number 
                                # !at least be 3 to start to change k2
my $file0 = 'nfiles.txt';
open(my $f0, ">",$file0) or die;   # > in writing style
print $f0 "$nfiles" ;
close($f0);  
										
my $step = $nfiles;
print "Run for $step steps. \n";
		 
#----get back number.txt--------------------

copy("./nfiles.txt","./solid")||warn "could not copy files :$!" ;



# copy source to solid documents


chdir "./solid";
find(\&wanted, "../source_solid");


# copy all matlab files and .inp files into the target file
sub wanted{
   if (-f $File::Find::name){
      if ($File::Find::name =~ /\.m$/){
          copy("$File::Find::name","../solid")||warn "could not copy files :$!" ;
     }
      if ($File::Find::name =~ /\.inp$/){
          copy("$File::Find::name","../solid")||warn "could not copy files :$!" ;
     }
     
    #  unlink $File::Find::name ;
   }
}

copy("../source_solid/aneurysm_thickness.igs",".")||warn "could not copy files :$!" ;


#--- Run ansys to get the mesh information then to creat the changed material parameter--------------------

	# output the element_centorid.dat file
	print "Run ANSYS to get the mesh information. \n";
	system("ansys161 -b -i run_mesh.inp -o ansys.out");
	sleep 10;


	print "generating material parameter input file for ansys \n";
	print "\n";
	 
	#deal with the element_centroid.dat--delete the ID
	copy("../curvature/removeMatrixID.m","../solid")||warn "could not copy files :$!" ; 
    system('matlab -nojvm -r removeMatrixID'); 
    sleep (10);


	print "generating input file for ansys output deformed geometry\n";
	print "\n";


	#interpolate the date with the principal curvature direction
	copy("../curvature/firstPrincipalCurvatureVector.dat","../solid")||warn "could not copy files :$!" ; 
	copy("../curvature/secondPrincipalCurvatureVector.dat","../solid")||warn "could not copy files :$!" ; 
	copy("../curvature/curvature_vector_interplation.mcr","../solid")||warn "could not copy files :$!" ; 		
    system ( "tecplot -b -p curvature_vector_interplation.mcr");
    sleep 10;

    #normlize the date 
    system('matlab -nojvm -r normlize_centriod_prinCurvaDir'); 
    sleep 10;

    #input the start state
    system('matlab -nojvm -r original_material_parameter_elements'); 
    sleep 10;

    system('matlab -nojvm -r creat_Element_Mat'); 
    sleep 10;



#--- define the loop for different time step--------------------	
	for my $i (1..$step) { 
 
		print "Run for number $i step. \n";

		my $step_file = $i;   

#---the value of  $i is replaced by $step_files, if the following sentence refers to the step number, should use  $step_files   


		my $file1 = 'step_file.txt';
		open(my $f1, ">",$file1) or die;   # > in writing style
		print $f1 "$step_file" ;
		close($f1);  

#---- Matlab to generate input file for ANSYS--------------------

		print "generating run file for ansys\n";
		print "\n";


		# deal with the different state of the value of K2 and C
		if($step_file==1||$step_file==2){
			my $k_c_fileName="./k_c_value".$step_file.".dat";
			unlink("./k_c_value.dat");
			sleep 5;
			rename("$k_c_fileName","./k_c_value.dat")
			or warn "Rename $k_c_fileName to ./k_c_value.dat failed: $!\n";

			system('matlab -nojvm -r writeMatPara'); 	
	    	sleep 20; 

	    	my $k_c_fileName_temp="./k_c_value".$step_file.".dat";
	    	sleep 3;
			rename("./k_c_value.dat","$k_c_fileName_temp")
			or warn "Rename ./k_c_value.dat to $k_c_fileName_temp failed: $!\n";
		}
		else{
			system('matlab -nojvm -r K2_change_material_parameter_elements');
			sleep 10;

			
			unlink('./k_c_value.dat');

			my $k_c_value_temp='./K2_change_value.dat';
			my $k_c_value='./k_c_value.dat';
			sleep 5;
			rename "$k_c_value_temp","$k_c_value"
			or warn "Rename $k_c_value_temp to $k_c_value failed: $!\n";

			sleep 10;

			system('matlab -nojvm -r writeMatPara'); 	
	    	sleep 20; 

	    	my $k_c_value2='./k_c_value2.dat';
	    	my $k_c_value_origin='./k_c_value.dat';
	    	unlink("$k_c_value2");
	    	sleep 5;
	    	rename("$k_c_value_origin","$k_c_value2")
	    	or warn "Rename $k_c_value_origin to $k_c_value2 failed: $!\n";
		}

		sleep 10;


		#matHGO.inp ---record the k2,c value of each element
	    my $matHGO='./matHGO.inp';
	    my $matHGOTemp='./matHGO'.$step_file.'.inp';
	    sleep 5;
		rename("$matHGO","$matHGOTemp")
		or warn "Rename $matHGO to $matHGOTemp failed: $!\n";
 

		sleep 10;
		

		 
#----run ANSYS to do the structural analysis with time-difference material paratemters--------------------
	    print "Run ANSYS to do the structural analysis. \n";
	    print "\n";
	    print "step $i begin\n";
	    print "\n";


	    #output the run file
	    system('matlab -nojvm -r output_deformed');
		sleep 10;

		system('matlab -nojvm -r write_run_file');
		sleep 10;

		 my $file3= 'run'.$step_file.'.inp';
		 unlink('run.inp'); 
		 sleep 5;
		 rename($file3,'run.inp')
		 or warn "Rename $file3 to run.inp failed: $!\n";
 
 		# go on the remodelling
		system("ansys161 -b -i run.inp -o ansys.out");

		sleep 20;


		#deal with the output file--stress
		my $stress_element='./stress_element'.$step_file.'.dat';
		my $stress_element_temp='./stress_element.dat';
		unlink("$stress_element_temp");
		sleep 5;
		rename("$stress_element","$stress_element_temp")
		or warn "Rename $stress_element to $stress_element_temp failed: $!\n";

		sleep 10;

		system('matlab -nojvm -r modify_standard_elementS1');
		sleep 20;


		# on the basis of different step to deal with the stress file and output the averageStress of each 
		#element
		if($step_file==1){
			my $element_averageStress_Matix='./element_averageStress_Matix.dat';
			my $element_averageStress_Matix_temp='./element_averageStress_Matix1.dat';
			sleep 5;
			move $element_averageStress_Matix,$element_averageStress_Matix_temp
			or warn "Rename $element_averageStress_Matix to $element_averageStress_Matix_temp failed: $!\n";

			sleep 10;
		}
		if($step_file==2){
			my $element_averageStress_Matix='./element_averageStress_Matix.dat';
			my $element_averageStress_Matix_temp='./element_averageStress_Matix2.dat';
			sleep 5;
			rename($element_averageStress_Matix,$element_averageStress_Matix_temp)
			or warn "Rename $element_averageStress_Matix to $element_averageStress_Matix_temp failed: $!\n";

			sleep 10;
		}
		if($step_file>2){
			my $element_averageStress_Matix='./element_averageStress_Matix.dat';
			my $element_averageStress_Matix_temp='./element_averageStress_Matix2.dat';
			unlink("$element_averageStress_Matix_temp");
			sleep 5;
			rename($element_averageStress_Matix,$element_averageStress_Matix_temp)
			or warn "Rename $element_averageStress_Matix to $element_averageStress_Matix_temp failed: $!\n";

			sleep 10;
		}
		

		
		if($step_file==1){
			 my $file4= 'run.inp';
			 sleep 3;
			 rename($file4,'run1.inp')
			 or warn "Rename $file4 to run1.inp failed: $!\n";
		}

}	

	print "\n";
		

