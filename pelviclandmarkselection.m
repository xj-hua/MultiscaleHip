
function plandmarks=pelviclandmarkselection(PS,RASISpcloud,LASISpcloud,RPTpcloud,LPTpcloud)

% PS (n*4): matrix for soid model of pelvis and spine
% RASISpcloud (n*1): point clouds for RASIS
% LASISpcloud (n*1): point clouds for LASIS
% RPTpcloud (n*1): point clouds for RPT
% LPTpcloud (n*1): point clouds for LPT


%%%%%%%%%%%%%%%%%%%%%%%%%------------------

% The matrix for point clouds of RASIS, LASIS, RPT and LPT
 
VCC1=RASISpcloud(:);
VCC1(VCC1==0)=[];
mc1=length(VCC1);
CC1=[];
for ic1=1:length(VCC1)
    CC1=[CC1;PS(PS(:,1)==VCC1(ic1),:)];
end

VCC2=LASISpcloud(:);                    
VCC2(VCC2==0)=[];
[mc2,nc2]=size(VCC2);
CC2=[];
for ic2=1:mc2
    CC2=[CC2;PS(PS(:,1)==VCC2(ic2),:)];
end

VCC3=RPTpcloud(:);                    
VCC3(VCC3==0)=[];
[mc3,nc3]=size(VCC3);
CC3=[];
for ic3=1:mc3
    CC3=[CC3;PS(PS(:,1)==VCC3(ic3),:)];
end

VCC4=LPTpcloud(:);                    
VCC4(VCC4==0)=[];
[mc4,nc4]=size(VCC4);
CC4=[];
for ic4=1:mc4
    CC4=[CC4;PS(PS(:,1)==VCC4(ic4),:)];
end

% To draw the node cloud for RASIS, LASIS, RPT and LPT

scatter3(CC1(:,2),CC1(:,3),CC1(:,4),'.','red');       % scatter plot for node cloud of RASIS, LASIS, PT
hold on;

scatter3(CC2(:,2),CC2(:,3),CC2(:,4),'.','red');
hold on;

scatter3(CC3(:,2),CC3(:,3),CC3(:,4),'.','red');
hold on;

scatter3(CC4(:,2),CC4(:,3),CC4(:,4),'.','red');
hold on;


%%%%%%%%%%%%%%%%%%%%%%%%%------------------
% The initial paramters for the iterative process


% The randomly selected four points from point clouds (the first row of C1, C2, C3 and C4)

midCC=(CC3(1,:)+CC4(1,:))/2;
APPplanevector=cross(CC2(1,2:4)-midCC(1,2:4),CC1(1,2:4)-midCC(1,2:4))/norm(cross(CC2(1,2:4)-midCC(1,2:4),CC1(1,2:4)-midCC(1,2:4)));

% The RASIS point translated 50 mm along the APPplanevector

movedpoint=CC1(1,2:4)+APPplanevector*80;                % The random point on RASIS translated 80 mm along the APPplanevector;
APPplaned=-(dot(APPplanevector,movedpoint));                % the plane passing through the midpoint

% The iteration for determing the RASIS, LASIS, RPT and LPT

nrasis=0;                    % The points set for the previous steps
nlasis=0;
nrpt=0;
nlpt=0;

nnrasis=1;                   % The points set for the current steps
nnlasis=1;
nnrpt=1;
nnlpt=1;


%%%%%%%%%%%%%%%%%%%%%%%%%------------------
% The iterative process for selecting exact landmarks of RASIS, LASIS, RPT and LPT

while nnrasis~=nrasis||nnlasis~=nlasis||nnrpt~=nrpt||nnlpt~=nlpt
    
     nrasis=nnrasis;
     nlasis=nnlasis;
     nrpt=nnrpt;
     nlpt=nnlpt;
    
    % RASIS
    drasis0=(abs(dot(APPplanevector,CC1(nnrasis,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
    for irasis=1:mc1
        drasis1=(abs(dot(APPplanevector,CC1(irasis,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
        if drasis1<drasis0
            nnrasis=irasis;
            drasis0=drasis1;
        end
    end
    
     % LASIS
    dlasis0=(abs(dot(APPplanevector,CC2(nnlasis,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
    for ilasis=1:mc2
        dlasis1=(abs(dot(APPplanevector,CC2(ilasis,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
        if dlasis1<dlasis0
            nnlasis=ilasis;
            dlasis0=dlasis1;
        end
    end

     % RPT
    drpt0=(abs(dot(APPplanevector,CC3(nnrpt,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
    for irpt=1:mc3
        drpt1=(abs(dot(APPplanevector,CC3(irpt,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
        if drpt1<drpt0
            nnrpt=irpt;
            drpt0=drpt1;
        end
    end

     % LPT
    dlpt0=(abs(dot(APPplanevector,CC4(nnlpt,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
    for ilpt=1:mc4
        dlpt1=(abs(dot(APPplanevector,CC4(ilpt,2:4))+APPplaned))/(sqrt(APPplanevector(1)^2+APPplanevector(2)^2+APPplanevector(3)^2));
        if dlpt1<dlpt0
            nnlpt=ilpt;
            dlpt0=dlpt1;
        end
    end
    
    midCC=(CC3(nnrpt,:)+CC4(nnlpt,:))/2;
    APPplanevector=cross(CC2(nnlasis,2:4)-midCC(1,2:4),CC1(nnrasis,2:4)-midCC(1,2:4))/norm(cross(CC2(nnlasis,2:4)-midCC(1,2:4),CC1(nnrasis,2:4)-midCC(1,2:4)));
    movedpoint=CC1(nnrasis,2:4)+APPplanevector*80; 
    APPplaned=-(dot(APPplanevector,movedpoint));
end

% To draw the point of RASIS, LASIS, RPT and LPT

scatter3(CC1(nnrasis,2),CC1(nnrasis,3),CC1(nnrasis,4),'filled','black');
hold on;
scatter3(CC2(nnlasis,2),CC2(nnlasis,3),CC2(nnlasis,4),'filled','black');
hold on;
scatter3(CC3(nnrpt,2),CC3(nnrpt,3),CC3(nnrpt,4),'filled','black');
hold on;
scatter3(CC4(nnlpt,2),CC4(nnlpt,3),CC4(nnlpt,4),'filled','black');
hold on;

%%
plandmarks=[CC1(nnrasis,1)
              CC2(nnlasis,1)
              CC3(nnrpt,1)
              CC4(nnlpt,1)];
 %%
 
 pRASIS=PS(PS(:,1)==CC1(nnrasis),:);
 pLASIS=PS(PS(:,1)==CC2(nnlasis),:);
 pRPT=PS(PS(:,1)==CC3(nnrpt),:);
 pLPT=PS(PS(:,1)==CC4(nnlpt),:);
 
 plandmarks=[pRASIS
             pLASIS
             pRPT
             pLPT
             ];
sprintf('The RASIS, LASIS, RPT LPT points are:')
disp(plandmarks)



