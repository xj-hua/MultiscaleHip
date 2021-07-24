clear,
clc


%----------------------------------------------------------
% Determine the four landmarks on pelvis for pelvic coordinate system

ScriptsFullPath=fileparts(mfilename('fullpath'));
cd([ScriptsFullPath]);
cd([cd,'/Example data']);

finp='Subchondral.inp';
fout='Subchondral_output.inp';

f_inp=fopen(finp,'r+');
f_out=fopen(fout,'r+');

str_NodeCoord_start='*NODE';
str_NodeCoord_end='**';

NodeSets=SetsExtract;

f_inp=fopen(finp,'r+');
M_NodeCoord=NodeSets.CoordSet(f_inp,str_NodeCoord_start,str_NodeCoord_end);
fclose(f_inp);

M_T_NodeCoord(:,1)=M_NodeCoord(:,1);
M_T_NodeCoord(:,2)=-M_NodeCoord(:,2);
M_T_NodeCoord(:,3)=-M_NodeCoord(:,3);
M_T_NodeCoord(:,4)=M_NodeCoord(:,4);


% Write inp file with transformed coordinate values for the nodes

f_inp=fopen(finp,'r+');

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
