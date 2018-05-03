clc;
close all;

% Load the input data
% We use the year of 2010 and with weather station 2
year='2010'; W='2'; DATA=[];
load(['../data/PWV_',year,'from_WS_',W,'_withGradient.mat']);

DOY=DATA(:,1);
Hour=DATA(:,2);
T=DATA(:,4);
SR=DATA(:,5);
RH=DATA(:,6);
DPT=DATA(:,8);
PWV=DATA(:,13);
Rain=DATA(:,7);

% Removing all spurious data points
f=find(PWV<=0);
PWV(f)=[]; DOY(f)=[]; Hour(f)=[]; T(f)=[]; SR(f)=[]; RH(f)=[]; DPT(f)=[]; Rain(f)=[];
i=isnan(PWV); f=find(i>0);
PWV(f)=[]; DOY(f)=[]; Hour(f)=[]; T(f)=[]; SR(f)=[]; RH(f)=[]; DPT(f)=[]; Rain(f)=[];
f=find(T<=0);
PWV(f)=[]; DOY(f)=[]; Hour(f)=[]; T(f)=[]; SR(f)=[]; RH(f)=[]; DPT(f)=[]; Rain(f)=[];
f=find(DPT<=0);
PWV(f)=[]; DOY(f)=[]; Hour(f)=[]; T(f)=[]; SR(f)=[]; RH(f)=[]; DPT(f)=[]; Rain(f)=[];
f=find(RH<=0);
PWV(f)=[]; DOY(f)=[]; Hour(f)=[]; T(f)=[]; SR(f)=[]; RH(f)=[]; DPT(f)=[]; Rain(f)=[];

Rain(Rain>0)=1;


X_matrix = horzcat(DOY, Hour, T, SR, RH, DPT, PWV);
X_matrix = X_matrix';
Group = Rain';

% Correlation between the features
A = horzcat(DOY, Hour, T, SR, RH, DPT, PWV);
R = corrcoef(A);

caxis([-1 1])
set(gca,'Xtick',1:7,'XTickLabel',{'D', 'H', 'T', 'SR', 'RH', 'DPT', 'PWV'});
set(gca,'Xtick',1:7,'YTickLabel',{'D', 'H', 'T', 'SR', 'RH', 'DPT', 'PWV'});

R_l=tril(R);
R_l(1:1,2:7)=NaN;
R_l(2:2,3:7)=NaN;
R_l(3:3,4:7)=NaN;
R_l(4:4,5:7)=NaN;
R_l(5:5,6:7)=NaN;
R_l(6:6,7:7)=NaN;

figure(1)
lowestValue = -1;
highestValue =1;

imagesc(R_l)
cmap = jet(256);
colormap(cmap);
caxis(gca,[lowestValue-2/256, highestValue]);
cmap(1,:)=[1,1,1];
colormap(cmap)
colorbar
set(gca,'Xtick',1:7,'XTickLabel',{'DoY', 'ToD', 'T', 'SR', 'RH', 'DPT', 'PWV'});
set(gca,'Xtick',1:7,'YTickLabel',{'DoY', 'ToD', 'T', 'SR', 'RH', 'DPT', 'PWV'});
title('Interdependency of Different Variables (2010)','FontName','Times','FontSize',12);
set(gca,'FontName','Times','FontSize',12)
xlabel('Variables','FontName','Times','FontSize',12)
ylabel('Variables','FontName','Times','FontSize',12)

