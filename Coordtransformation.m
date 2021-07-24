function TM=Coordtransformation(M_origin, Coord_local_orgin, Coord_local_vector)

IM=M_origin(:,2:4);

ix=[1,0,0];
iy=[0,1,0];
iz=[0,0,1];

OP=Coord_local_orgin;

pvx=Coord_local_vector(1,:);
pvy=Coord_local_vector(2,:);
pvz=Coord_local_vector(3,:);


% The direction cosine of the aixs of the pelvis coordinate system (the cosine of the angle between the unit vector and the three image axies)

% the direction cosine of the pvx
cospvxix=dot(pvx,ix)/(norm(pvx)*norm(ix));
cospvxiy=dot(pvx,iy)/(norm(pvx)*norm(iy));
cospvxiz=dot(pvx,iz)/(norm(pvx)*norm(iz));

% the direction cosine of the pvy
cospvyix=dot(pvy,ix)/(norm(pvy)*norm(ix));
cospvyiy=dot(pvy,iy)/(norm(pvy)*norm(iy));
cospvyiz=dot(pvy,iz)/(norm(pvy)*norm(iz));

% the direction cosine of the pvz
cospvzix=dot(pvz,ix)/(norm(pvz)*norm(ix));
cospvziy=dot(pvz,iy)/(norm(pvz)*norm(iy));
cospvziz=dot(pvz,iz)/(norm(pvz)*norm(iz));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Transfer from image coordinate system to pelvis coordinate system

IMx=IM(:,1)-OP(1);                  % The x,y,z coordinate of matrix PA in image coordinate system
IMy=IM(:,2)-OP(2);
IMz=IM(:,3)-OP(3);

PMx=IMx*cospvxix+IMy*cospvxiy+IMz*cospvxiz;     % The PA matrix in image coordinate system was transfered into pelvis coordinate system
PMy=IMx*cospvyix+IMy*cospvyiy+IMz*cospvyiz;
PMz=IMx*cospvzix+IMy*cospvziy+IMz*cospvziz;

TM=[M_origin(:,1) PMx PMy PMz];                       % The PA matrix in pelvis coordinate system
