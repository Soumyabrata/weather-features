clc;
close all;

% Extracting the weather station data
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

X_matrix = horzcat( DOY,Hour, T, SR, RH, DPT, PWV);
Group = Rain;

% Normalizing the Data
Norm_Mat=[];
for k=1:7
   t=[]; t=X_matrix(:,k);
   m=[]; m=mean(t);
   temp=[]; temp=(t-m)./std(t);
   Norm_Mat(:,k)=temp;   
end

% PCA
[coeff,score,latent,explained] = pca(Norm_Mat);
coeff;

% Calculating the covariance matrix
covMat=[]; covMat = cov(Norm_Mat);
Ve=[]; [Ve, ~] = eig(covMat);

% Relative loadings (co-efficients for the input variables)
p=[]; p = Ve(:,end:-1:1);

% Plot the PC variance and the Components
vari=[]; vari=(latent./sum(latent)).*100;


figure(1)
bar(vari)
set(gca,'Xtick',1:7,'XTickLabel',{'PC1', 'PC2', 'PC3', 'PC4', 'PC5', 'PC6', 'PC7'});
xlabel('Principal Components','FontName','Times','FontSize',12)
ylabel('Variance Explained (%)','FontName','Times','FontSize',12)
ylim([0 50])


