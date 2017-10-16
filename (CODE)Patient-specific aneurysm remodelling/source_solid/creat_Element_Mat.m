%%read files
IDelement_centroid=load('.\element_centroid.dat');
[num,~]=size(IDelement_centroid);

write_filePath='.\Element_Mat.inp';
write_filePath_fid=fopen(write_filePath,'wt');

for i=1:num
    fprintf(write_filePath_fid,'EMODIF,%d,Mat,%d\n',IDelement_centroid(i,1),IDelement_centroid(i,1));
end

fclose(write_filePath_fid);

%%
exit;