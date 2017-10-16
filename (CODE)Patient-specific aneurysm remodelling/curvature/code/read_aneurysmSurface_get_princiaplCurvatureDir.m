%% Summary
%Author: Yifan Pu
%Last Update: August 2017

%%
%Clear all variables, close all windows and clear command window 
clear all
close all
clc
%% Read the files 
%inner artery and aneurysm
filePath1='.\aneurysm_inner.stl';
%outer artery and aneurysm
filePath2='.\aneurysm_outersurface.stl';

%read the inner artery and aneurysm file
m1=stl_read_binary(filePath1);
%read the outer artery and aneurysm file
m2=stl_read_binary(filePath2);

FV1.faces =m1.faces;
FV1.vertices=m1.vertices;

FV2.faces =m2.faces;
FV2.vertices=m2.vertices;


%% calcualte curvatures
getderivatives=0;
[PrincipalCurvatures1,PrincipalDir11,PrincipalDir21,FaceCMatrix1,VertexCMatrix1,Cmagnitude1]= GetCurvatures( FV1 ,getderivatives);

[PrincipalCurvatures2,PrincipalDir12,PrincipalDir22,FaceCMatrix2,VertexCMatrix2,Cmagnitude2]= GetCurvatures( FV2 ,getderivatives);
% GausianCurvature=PrincipalCurvatures(1,:).*PrincipalCurvatures(2,:);

%% get the triangle centroid
TR1 = triangulation(FV1.faces,FV1.vertices);
centroidTriangle1=[];
for i=1:size(FV1.faces)
    X=sum(TR1.Points(TR1.ConnectivityList(i,:),1))/3;
    Y=sum(TR1.Points(TR1.ConnectivityList(i,:),2))/3;
    Z=sum(TR1.Points(TR1.ConnectivityList(i,:),3))/3;
    centroidTriangle1=[centroidTriangle1;X Y Z];
end

TR2 = triangulation(FV2.faces,FV2.vertices);
centroidTriangle2=[];
for i=1:size(FV2.faces)
    X=sum(TR2.Points(TR2.ConnectivityList(i,:),1))/3;
    Y=sum(TR2.Points(TR2.ConnectivityList(i,:),2))/3;
    Z=sum(TR2.Points(TR2.ConnectivityList(i,:),3))/3;
    centroidTriangle2=[centroidTriangle2;X Y Z];
end


%% Analysis the matrix and write to the file


%first principal curvature direction of inner aneurysm
principalDirection11=PrincipalDir11(1:3:end,:);
%second principal curvature direction of inner aneurysm
principalDirection21=PrincipalDir21(1:3:end,:);

%first principal curvature direction of outer aneurysm
principalDirection12=PrincipalDir12(1:3:end,:);
%second principal curvature direction of outer aneurysm
principalDirection22=PrincipalDir22(1:3:end,:);

path1='..\firstPrincipalCurvatureVector.dat';
path2='..\secondPrincipalCurvatureVector.dat';
%open the file steam
fid1=fopen(path1,'wt');
fid2=fopen(path2,'wt');


m1=size(centroidTriangle1(:,1));%inner aneurysm center pointer 
k1=size(principalDirection11(:,1));%first principal curvature direction of inner aneurysm
k2=size(principalDirection12(:,1));%first principal curvature direction of outer aneurysm

fprintf(fid1,'VARIABLES = "X","Y","Z","VA1","VA2","VA3"\n');
%firstPrincipalCurvatureVector.txt date
if k1==m1
    for i=1:m1
         fprintf(fid1,'%.8f %.8f %.8f %.8f %.8f %.8f\n',...
         centroidTriangle1(i,1),centroidTriangle1(i,2),centroidTriangle1(i,3),...
         principalDirection11(i,1),principalDirection11(i,2),principalDirection11(i,3));
    end
    disp('finish firstPrincipalCurvatureVector inner part');
    for i=1:m1
         fprintf(fid1,'%.8f %.8f %.8f %.8f %.8f %.8f\n',...
         centroidTriangle2(i,1),centroidTriangle2(i,2),centroidTriangle2(i,3),...
         principalDirection12(i,1),principalDirection12(i,2),principalDirection12(i,3));
    end
    disp('finish firstPrincipalCurvatureVector outer part');
else
    disp('the data row does not match');
end

fclose(fid1);

%secondPrincipalCurvatureVector.txt date

fprintf(fid2,'VARIABLES = "X","Y","Z","VB1","VB2","VB3"\n');
if k2==m1
    for i=1:m1
         fprintf(fid2,'%.8f %.8f %.8f %.8f %.8f %.8f\n',...
         centroidTriangle1(i,1),centroidTriangle1(i,2),centroidTriangle1(i,3),...
         principalDirection21(i,1),principalDirection21(i,2),principalDirection21(i,3));
    end
    disp('finish secondPrincipalCurvatureVector inner part');
    for i=1:m1
         fprintf(fid2,'%.8f %.8f %.8f %.8f %.8f %.8f\n',...
         centroidTriangle2(i,1),centroidTriangle2(i,2),centroidTriangle2(i,3),...
         principalDirection22(i,1),principalDirection22(i,2),principalDirection22(i,3));
    end
    disp('finish secondPrincipalCurvatureVector outer part');
else
    disp('the data row does not match');
end

fclose(fid2);
