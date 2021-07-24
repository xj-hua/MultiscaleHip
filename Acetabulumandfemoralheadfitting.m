clear,
clc


%----------------------------------------------------------
% Determine the four landmarks on pelvis for pelvic coordinate system

fpath='C:\Users\xhua\Documents\Xijin Hua_MSCHIPBIO project\Multiscale modelling development_different activities_20190327\Matlab and python code_20190324\Data processing\'

fname_inp='Femur.inp';

finp=[fpath fname_inp];


str_NodeCoord_start='*NODE';
str_NodeCoord_end='**';


str_acetabulum_start='*NSET, NSET=SET_NODES_Femoralhead';
str_acetabulum_end='**ANSA_COLOR;5;SHELL_SECTION;0.;.501960813999176;0.;1.;';

% str_femoralhead_start='*NSET, NSET=SET_NODES_femur';
% str_femoralhead_end='**ANSA_COLOR;1;SHELL_SECTION;1.;0.;0.;1.;';


NodeSets=SetsExtract;

f_inp=fopen(finp,'r+');
M_NodeCoord=NodeSets.CoordSet(f_inp,str_NodeCoord_start,str_NodeCoord_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_acetabulum=NodeSets.NodeSet(f_inp,str_acetabulum_start,str_acetabulum_end);
fclose(f_inp);

% f_inp=fopen(finp,'r+');
% M_femoralhead=NodeSets.NodeSet(f_inp,str_femoralhead_start,str_femoralhead_end);
% fclose(f_inp);


[acetabulum_centre,acetabulum_radius]=AcetabularFitting(M_NodeCoord,M_acetabulum)
% [femoralhead_centre,femoralhead_radius]=AcetabularFitting(M_NodeCoord,M_femoralhead)





