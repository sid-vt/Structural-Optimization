clear;clc;
%% Schmit3bar is a script to drive solution of a plane 3-bar truss
% "Structural Design by Systematic Synthesis"
%  by Lucien Schmit, Jr., 1960
%
% Written by: Robert A. Canfield
%             Air Force Institute of Technology
%             AFIT/ENY
%             2950 Hobson Way, Bldg. 640
%             WPAFB, OH 45433-7765
%
% Created: 26 Mar 2006
% Revised:  8 Oct 2015
%
%--Global structure variables set in this script
%
%  FEM... Finite Element Model structure with following fields
%         mesh..... Nodal connectivity matrix for the mesh, one row per element
%         xyz...... Nodal x, y and z coordinates, one row for each node
%         Area..... Cross-Sectional Area for each element (vector)
%         Material. Structure of material properties
%                   E......... Young's Modulus for all elements (scalar)
%                   density... mass density
%                   tension... Allowable axial stress in tension
%                   compress.. Allowable axial stress in compression
%         BC....... Boundary Conditions  Structure with fields: node, direction, magnitude
%         Load..... External Point Loads Structure with fields: node, direction, magnitude
%                   Each field is a cell array indexed to each load case
%         K........ Global Stiffness matrix
%         D........ Global nodal displacement vector
%
%--External references
%
%  FEAtruss....... Finite Element Analysis solver for trusses
%  FEAtrussPost... Script to post-process FEA results
%
%--Modifications
%  10/8/15 - clear only FEM so that CaseInput can bet set
%
%--BEGIN
%
%  Save output to a log file
%
clear FEM
format compact
% diary Schmit3bar
%
%% Fixed parameters for Schmit's 3-bar truss
%
BarAngle = [135 90 45];
Height = 1;
FEM.Material.E = 1;
FEM.Material.density = 1;
FEM.Material.tension = 20;
FEM.Material.compress = -15;
%
%% Case-dependent loading and properties
%
% if ~exist('CaseInput','var'), CaseInput=1; end

CaseInput=1;
%%
switch CaseInput
   case 1
      nlc = 2;
      LoadAngle = [60 180];
      ApexLoad  = [30 20];
      FEM.Area0 = [1 1 1]; % Initial cycle 1 areas
      FEM.Area  = [1.072 0.544 0.611]; % Final areas
   case 2
      nlc = 3;
      LoadAngle = [45 90 135];
      ApexLoad  = [40 30 20];
      FEM.Material.tension  =  [5 20 5];
      FEM.Material.compress = -[5 20 5];
      FEM.Area0 = [8 2.4 3.2]; % Initial cycle 1 areas
      FEM.Area  = [7.099 1.849 2.897]; % Final areas
    case 3
      nlc = 3;
      LoadAngle = [45 90 135];
      ApexLoad  = [20 15 10];
      FEM.Material.tension = 10;
      FEM.Material.compress = -10;
      FEM.Area0 = [2 2 2]; % Initial cycle 1 areas
      FEM.Area  = [1.707 0.940 0.526]; % Final areas
   case 4
      nlc = 2;
      LoadAngle = [45 135];
      ApexLoad  = [20 20];
      FEM.Area0 = [1 1 1]; % Initial cycle 1 areas
      FEM.Area  = [0.784 0.422 0.784]; % Final areas
end
%
%% Nodal coordinates
%
FEM.xyz=Height*[[cot(deg2rad(BarAngle)) 0]; [1 1 1 0]]';
figure(1), hold on
plotnodes(FEM.xyz)
%
%  Define nodal connectivity for mesh
%
FEM.mesh=[
     1     4
     2     4
     3     4
];
plotmesh( FEM.mesh, FEM.xyz ); hold off
title('Element & Node numbers')
%
%%  Boundary conditions and Loads
%
FEM.BC.node = [1 2 3 1 2 3];
FEM.BC.direction = [1 1 1 2 2 2];
for n=1:nlc
   FEM.Load.node{n} = [4 4];
   FEM.Load.direction{n} = [1 2];
   FEM.Load.magnitude{n} = ApexLoad(n)*[cos(deg2rad(LoadAngle(n))), -sin(deg2rad(LoadAngle(n)))];
end
%
%%  Call script to conduct finite element analysis
%
% FEAtruss
%

%% Fully Stressed Design:
Amin = 0.001;
while true
FEAtruss

tensionRatio = max(FEM.stress./FEM.Material.tension',[],2);
compressRatio = max(FEM.stress./FEM.Material.compress',[],2);


Area = FEM.Area;
if tensionratio(e) > compressratio(e)
    Area(e) = Area(e)*tensionratio(e);
else
    Area(e) = Area(e)*compressratio(e);
end
if Area(e) < Amin
    Area(e) = Amin;
    elemnotatgauge = [elemvec(1:e-1); elemvec(e+1:end)];
end 
%%  Post-processor for printing results
%
if CaseInput>1, for line=1:6, disp(' '), end, end
disp(['Schmit 3-bar truss: Case Input = ', num2str(CaseInput)])
FEAtrussPost
disp(' ')
disp('Schmit Behavior Matrix')
B = [FEM.stress; FEM.D(FEM.u,:)] %#ok<NOPTS>
%
%  Turn off log file
%
% diary off 