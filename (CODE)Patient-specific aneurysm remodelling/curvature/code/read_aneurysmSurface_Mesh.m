%% Summary
%Author: Yifan Pu
%Last Update: August 2017
%%
%Clear all variables, close all windows and clear command window 
clear all
close all
clc
%% Read the files 
%aneurysm path
% filePath='aneurysmRepresentDemo\aneurysm5\aneurysm5.stl';

filePath='aneurysm_inner.stl';

m=stl_read_binary(filePath);

FV.faces =m.faces;
FV.vertices=m.vertices;

%% calcualte curvatures direction
getderivatives=0;
[PrincipalCurvatures,PrincipalDir1,PrincipalDir2,FaceCMatrix,VertexCMatrix,Cmagnitude]= GetCurvatures( FV ,getderivatives);

TR = triangulation(FV.faces,FV.vertices);
centroidTriangle=[];
for i=1:size(FV.faces)
    X=sum(TR.Points(TR.ConnectivityList(i,:),1))/ 3;
    Y=sum(TR.Points(TR.ConnectivityList(i,:),2))/3;
    Z=sum(TR.Points(TR.ConnectivityList(i,:),3))/3;
    centroidTriangle=[centroidTriangle;X Y Z];
end

%% Draw the mesh to the screen 

figure('name','aneurysm principal curvature direction','numbertitle','off','color','w');

quiver3(centroidTriangle(:,1),centroidTriangle(:,2),centroidTriangle(:,3),...
    PrincipalDir1(1:3:end,1),PrincipalDir1(1:3:end,2),PrincipalDir1(1:3:end,3),'r');

hold on; 

quiver3(centroidTriangle(:,1),centroidTriangle(:,2),centroidTriangle(:,3),...
    PrincipalDir2(1:3:end,1),PrincipalDir2(1:3:end,2),PrincipalDir2(1:3:end,3),'b');


axis off


view([-45,35.2]);
camlight();
lighting phong