%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To establish the pelvis coordinate system and draw pelvis coordinate planes

function M_CoordSystem=pelviccoordinatesystem(PS,pelviclandmarks)

% PS (n*4): matrix for solid model of pelvis and spine
% pelviclandmarks (4*1): the selected exact bony landmarks on pelvis using iterative progress (function pelviclandmarkselection)
%                        the node numbers of the exact bony landmarks.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-------------------------------

% (1) to transfer the node set (node number) to coordinate matrix (node number, three coordinate values)

VCC=pelviclandmarks(:);                      % The landmarks, 1st row: RASIS, 2nd row: LASIS, 3rd row: LPT, 4th row: RPT
VCC(VCC==0)=[];
CC=[];

for ic=1:length(VCC)
    CC=[CC;PS(PS(:,1)==VCC(ic),:)];
end

rasis=[CC(1,2),CC(1,3),CC(1,4)];
lasis=[CC(2,2),CC(2,3),CC(2,4)];
mpt=[(CC(3,2)+CC(4,2))/2,(CC(3,3)+CC(4,3))/2,(CC(3,4)+CC(4,4))/2];          % Midpoint of RPT and LPT
masis=(rasis+lasis)/2;                                                      % Midpoint of RASIS and LASIS

LC=[rasis,                  % The landmarks, 1st row: RASIS, 2nd row: LASIS, 3rd row: MPT
    lasis,
    mpt
    rasis];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-----------------------------------

% (2) To establish the pelvis coordinate system and draw the coordinate planes

% The centre of pelvis coordinate system OP

OP=mpt;
disp(sprintf('The centre of the pelvis coordinate system is OP (%f,%f,%f)',OP));

% the length and width of the coordinate planes

planelength=sqrt((rasis(1)-lasis(1))^2+(rasis(2)-lasis(2))^2+(rasis(3)-lasis(3))^2)*0.5; % The length of the pelvis coordinate plane
planewidth=sqrt((masis(1)-mpt(1))^2+(masis(2)-mpt(2))^2+(masis(3)-mpt(3))^2)*3;              % The width of the pelvis coordinate plane 

% the axias of the pelvis coordinate systen

pvx=(rasis-masis)/norm(rasis-masis);                       % the x-axis of the pelvis coordinate system (vector from masis to rasis)
pvy=cross(pvx,mpt-masis)/norm(cross(pvx,mpt-masis));       % the y-axis of the pelvis coordinate system        
pvz=cross(pvx,pvy);                                        % the z-aixs of the pelvis coordinate system
M=[pvx' pvy' pvz'];                          % M is a mapping matrix from old coordinate system to new coordinate system

%%%%%%%%%%%%%%%---------------------------------------------------------------

%  %%%%%%%% The Coronal plane

% The Coronal plane include RASIS, LASIS, MPT, the plane equation is: a*x+b*y+c*z+d=0

ncoronal=cross(lasis-mpt,rasis-mpt);                                 % the normal vector of Coronal plane
uncoronal=[ncoronal,0-(ncoronal(1)*mpt(1)+ncoronal(2)*mpt(2)+ncoronal(3)*mpt(3))]/norm(ncoronal);                     % To transfer the normal vector of coronal plane to unit vector
disp(sprintf('The Coronal plane equation for pelvis is:%f*x+%f*y+%f*z+%f=0',uncoronal(1),uncoronal(2),uncoronal(3),uncoronal(4)));

% to draw the Coronal plane

coronalx=[-planelength/2:planelength/2];
coronalz=[-planelength/3:planelength*2/3];
[gcoronalx gcoronalz]=meshgrid(coronalx,coronalz);
gcoronaly=zeros(size(gcoronalx));

lcoronalx=reshape(gcoronalx,1,[]);
lcoronaly=reshape(gcoronaly,1,[]);
lcoronalz=reshape(gcoronalz,1,[]);
Newcoronal=M*[lcoronalx;lcoronaly;lcoronalz];

Newcoronalx=reshape(Newcoronal(1,:),size(gcoronalx))+mpt(1);
Newcoronaly=reshape(Newcoronal(2,:),size(gcoronalx))+mpt(2);
Newcoronalz=reshape(Newcoronal(3,:),size(gcoronalx))+mpt(3);

coronalsurf=surf(Newcoronalx,Newcoronaly,Newcoronalz);
set(coronalsurf,'facecolor','red','edgecolor','none');
alpha(0.5);
grid off
hold on
plot3(LC(:,1),LC(:,2),LC(:,3),'o-','LineWidth',2);
hold on

%%%%%%%%%%%%%%%---------------------------------------------------------------

%  %%%%%%%% The Sagittal plane

% The Sagital plane perpendicular to the line connecting the rasis and lasis, containing the mpt, 
% the plane equation is: a*x+b*y+c*z+d=0

nsagittal=rasis-masis;
unsagittal=[nsagittal,0-(nsagittal(1)*mpt(1)+nsagittal(2)*mpt(2)+nsagittal(3)*mpt(3))]/norm(nsagittal);                % To transfer the normal vector of Sagittal plane to unit vector
disp(sprintf('The Sagittal plane equation for pelvis is:%f*x+%f*y+%f*z+%f=0',unsagittal(1),unsagittal(2),unsagittal(3),unsagittal(4)));

% to draw the Sagittal plane

sagittaly=[-planelength:0];
sagittalz=[-planelength/3:planelength*2/3];
[gsagittaly gsagittalz]=meshgrid(sagittaly,sagittalz);
gsagittalx=zeros(size(gsagittaly));

lsagittalx=reshape(gsagittalx,1,[]);
lsagittaly=reshape(gsagittaly,1,[]);
lsagittalz=reshape(gsagittalz,1,[]);
Newsagittal=M*[lsagittalx;lsagittaly;lsagittalz];

Newsagittalx=reshape(Newsagittal(1,:),size(gsagittalx))+mpt(1);
Newsagittaly=reshape(Newsagittal(2,:),size(gsagittaly))+mpt(2);
Newsagittalz=reshape(Newsagittal(3,:),size(gsagittalz))+mpt(3);

sagittalsurf=surf(Newsagittalx,Newsagittaly,Newsagittalz);
set(sagittalsurf,'facecolor','green','edgecolor','none');
alpha(0.5);
hold on


%%%%%%%%%%%%%%%----------------------------------------------------------------------

%  %%%%%%%% The Axial plane

% The Axial plane perpendicular to the Coronal plane, Sagittal plane and contain the mpt point  
% the plane equation is: a*x+b*y+c*z+d=0

naxial=cross(unsagittal(:,1:3),uncoronal(:,1:3));
unaxial=[naxial,0-(naxial(1)*mpt(1)+naxial(2)*mpt(2)+naxial(3)*mpt(3))]/norm(naxial);
disp(sprintf('The Axial plane equation for pelvis is:%f*x+%f*y+%f*z+%f=0',unaxial(1),unaxial(2),unaxial(3),unaxial(4)));

% to draw the Sagittal plane
axialx=[-planelength/2:planelength/2];
axialy=[-planelength:0];
[gaxialx gaxialy]=meshgrid(axialx,axialy);
gaxialz=zeros(size(gaxialx));

laxialx=reshape(gaxialx,1,[]);
laxialy=reshape(gaxialy,1,[]);
laxialz=reshape(gaxialz,1,[]);
Newaxial=M*[laxialx;laxialy;laxialz];

Newaxialx=reshape(Newaxial(1,:),size(gaxialx))+mpt(1);
Newaxialy=reshape(Newaxial(2,:),size(gaxialy))+mpt(2);
Newaxialz=reshape(Newaxial(3,:),size(gaxialz))+mpt(3);

axialsurf=surf(Newaxialx,Newaxialy,Newaxialz);
set(axialsurf,'facecolor','blue','edgecolor','none');
alpha(0.5);
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-----------------------------------
% To creat x-aixs, y-axis, z-axis of coordinate system with arrows

axislength=planelength/5;
plot3(OP(1),OP(2),OP(3),'k','MarkerSize',5);
hold on;
quiver3(OP(1),OP(2),OP(3),pvx(1),pvx(2),pvx(3),axislength,'k','linewidth',2);     % x-axis
quiver3(OP(1),OP(2),OP(3),pvy(1),pvy(2),pvy(3),axislength,'k','linewidth',2);     % y-axis
quiver3(OP(1),OP(2),OP(3),pvz(1),pvz(2),pvz(3),axislength,'k','linewidth',2);     % z-axis

% To add text in x-aixs, y-axis, z-axis of coordinate system with arrows

text(OP(1)+pvx(1)*axislength*1.2,OP(2)+pvx(2)*axislength*1.2,OP(3)+pvx(3)*axislength*1.2,'x','FontSize',15,'FontWeight','demi','rotation',0);
text(OP(1)+pvy(1)*axislength*1.2,OP(2)+pvy(2)*axislength*1.2,OP(3)+pvy(3)*axislength*1.2,'y','FontSize',15,'FontWeight','demi','rotation',0);
text(OP(1)+pvz(1)*axislength*1.2,OP(2)+pvz(2)*axislength*1.2,OP(3)+pvz(3)*axislength*1.2,'z','FontSize',15,'FontWeight','demi','rotation',0);
text(OP(1)-pvx(1)*axislength*0.2,OP(2)-pvx(2)*axislength*0.2,OP(3)-pvx(3)*axislength*0.2,'Op','FontSize',12,'FontWeight','demi','rotation',0);

M_CoordSystem=[pvx
               pvy
               pvz];

