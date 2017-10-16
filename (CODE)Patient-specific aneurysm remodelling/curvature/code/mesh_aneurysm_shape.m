%% Summary
%Author: Yifan Pu
%Last Update: August 2017
%%
%Clear all variables, close all windows and clear command window 
clear 
close all
clc
%% read file and Generate the aneurysm

filePath='aneurysmRepresentDemo\aneurysm1\aneurysm1.stl';

m=stl_read_binary(filePath);

FV.faces =m.faces;
FV.vertices=m.vertices;

%% calcualte curvatures
getderivatives=0;
[PrincipalCurvatures,PrincipalDir1,PrincipalDir2,FaceCMatrix,VertexCMatrix,Cmagnitude]= GetCurvatures( FV ,getderivatives);

GausianCurvature=PrincipalCurvatures(1,:).*PrincipalCurvatures(2,:);
%% Draw the mesh to the screen 
figure('name','Triangle Mesh Curvature Example','numbertitle','off','color','w');
colormap cool
caxis([min(GausianCurvature) max(GausianCurvature)]); % color overlay the gaussian curvature
mesh_h=patch(FV,'FaceVertexCdata',GausianCurvature','facecolor','interp','edgecolor','interp','EdgeAlpha',0.2);
%set some visualization properties
set(mesh_h,'ambientstrength',0.35);
axis off
view([-45,35.2]);
camlight();
lighting phong
colorbar();