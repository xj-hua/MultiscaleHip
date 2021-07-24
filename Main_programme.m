clear,
clc


%----------------------------------------------------------
% Determine the four landmarks on pelvis for pelvic coordinate system

ScriptsFullPath=fileparts(mfilename('fullpath'));
cd([ScriptsFullPath]);
cd([cd,'/Example data']);

finp='Pelvis and femur_local.inp';
fout='Pelvis and femur_pelvic_output.inp';

f_inp=fopen(finp,'r+');

str_NodeCoord_start='*NODE';
str_NodeCoord_end='**';

str_NodeRASIS_start='*NSET, NSET=SET_NODES_RASIS';
str_NodeRASIS_end='**ANSA_ID;2;';

str_NodeLASIS_start='*NSET, NSET=SET_NODES_LASIS';
str_NodeLASIS_end='**ANSA_ID;3;';

str_NodeRPT_start='*NSET, NSET=SET_NODES_RPT';
str_NodeRPT_end='**ANSA_ID;4;';

str_NodeLPT_start='*NSET, NSET=SET_NODES_LPT';
str_NodeLPT_end='**ANSA_ID;5;';

str_Lacetabulum_start='*NSET, NSET=SET_NODES_Lacetabulum';
str_Lacetabulum_end='**ANSA_ID;6;';

str_Lfemur_start='*NSET, NSET=SET_NODES_Lfemur';
str_Lfemur_end='**ANSA_COLOR;1;SHELL_SECTION;.952941179275513;.874509811401367;.105882354080677;1';

NodeSets=SetsExtract;

f_inp=fopen(finp,'r+');
M_NodeCoord=NodeSets.CoordSet(f_inp,str_NodeCoord_start,str_NodeCoord_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_RASIS=NodeSets.NodeSet(f_inp,str_NodeRASIS_start,str_NodeRASIS_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_LASIS=NodeSets.NodeSet(f_inp,str_NodeLASIS_start,str_NodeLASIS_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_RPT=NodeSets.NodeSet(f_inp,str_NodeRPT_start,str_NodeRPT_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_LPT=NodeSets.NodeSet(f_inp,str_NodeLPT_start,str_NodeLPT_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_Lacetabulum=NodeSets.NodeSet(f_inp,str_Lacetabulum_start,str_Lacetabulum_end);
fclose(f_inp);

f_inp=fopen(finp,'r+');
M_Lfemur=NodeSets.NodeSet(f_inp,str_Lfemur_start,str_Lfemur_end);
fclose(f_inp);

PL=pelviclandmarkselection(M_NodeCoord,M_RASIS,M_LASIS,M_RPT,M_LPT);

PL_Nsets=PL(:,1);
M_localsystem=pelviccoordinatesystem(M_NodeCoord,PL_Nsets);          % The vectors for axis of pelvic coordinte system

[Lacetabulum_centre,Lacetabulum_radius]=AcetabularFitting(M_NodeCoord,M_Lacetabulum);
[Lfemur_centre,Lfemur_radius]=AcetabularFitting(M_NodeCoord,M_Lfemur);

M_T_NodeCoord=Coordtransformation(M_NodeCoord,Lacetabulum_centre,M_localsystem); % Transformation of the Coordinate value matrix from AnyBody local coordinate system to the pelvic coordinate system

% Write inp file with transformed coordinate values for the nodes

f_inp=fopen(finp,'r+');
f_out=fopen(fout,'r+');

while ~feof(f_inp)
    fline=fgetl(f_inp);
    if strcmp(fline,str_NodeCoord_start)
        fprintf(f_out,'*NODE\r\n');
        while ~strcmp(fline,str_NodeCoord_end)
            fline=fgetl(f_inp);
        end
        fprintf(f_out,'\t%d,\t%f,\t%f,\t%f\r\n',M_T_NodeCoord');
        fprintf(f_out,'**\r\n');
    else
        fprintf(f_out,'%s\r\n',fline);
    end
end

fclose(f_inp);
fclose(f_out);



