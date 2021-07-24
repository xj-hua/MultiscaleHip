function M_sets=SetsExtract

M_sets.CoordSet=@CoordSet;
M_sets.NodeSet=@NodeSet;

end


    function M_Coord=CoordSet(f_inp,str_NodeCoord_start,str_NodeCoord_end)
        M_Coord=[];
        while ~feof(f_inp)
            fline=fgetl(f_inp);
            if strcmp(fline,str_NodeCoord_start)
                while ~strcmp(fline,str_NodeCoord_end)
                    fline=fgetl(f_inp);
                    if ~strcmp(fline,str_NodeCoord_end)
                        M_Coord=[M_Coord;str2num(fline)];
                    end
                end
            end
        end
    end
    
    function M_NodeSet=NodeSet(f_inp,str_NodeSets_start,str_NodeSets_end)
        M_NodeSet=[];
        while ~feof(f_inp)
            fline=fgetl(f_inp);
            if strcmp(fline,str_NodeSets_start)
                while ~strcmp(fline,str_NodeSets_end)
                    fline=fgetl(f_inp);
                    if ~strcmp(fline,str_NodeSets_end)
                        M_NodeSet=[M_NodeSet,str2num(fline)];
                    end
                end
            end
        end
    end
     