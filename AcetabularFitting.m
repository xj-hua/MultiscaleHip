% Circle fitting

function [Cir_centre,Cir_radius]=AcetabularFitting(PS,M_acetabulum)

VCC=M_acetabulum(:);
VCC(VCC==0)=[];
data=[];

for i=1:length(VCC)
    data=[data;PS(PS(:,1)==VCC(i),2:4)];
end

f=@(p,data)(data(:,1)-p(1)).^2+(data(:,2)-p(2)).^2+(data(:,3)-p(3)).^2-p(4)^2;
p=nlinfit(data,zeros(size(data,1),1),f,[0 0 0 1]');                     %Surface fitting

hold on;

plot3(data(:,1),data(:,2),data(:,3),'o');

[X,Y,Z]=meshgrid(linspace(-24,24),linspace(-24,24),linspace(-25,-1,50));

V1=(X-p(1)).^2+(Y-p(2)).^2+(Z-p(3)).^2-p(4)^2;
isosurface(X,Y,Z,V1,0);
alpha .5;camlight;axis equal;grid on;view(3);
title(sprintf('(x-%f)^2+(y-%f)^2+(z-%f)^2=%f',p(1),p(2),p(3),p(4)^2))

Cir_centre=[p(1) p(2) p(3)];
Cir_radius=abs(p(4));