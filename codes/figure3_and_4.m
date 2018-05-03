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



% With Downsampling 

minor_indi=[]; minor_indi=find(Rain==1);
PWV_rain=[]; PWV_rain=PWV(minor_indi);
DOY_rain=[]; DOY_rain=DOY(minor_indi);
Hour_rain=[]; Hour_rain=Hour(minor_indi);
T_rain=[]; T_rain=T(minor_indi);
RH_rain=[]; RH_rain=RH(minor_indi);
DPT_rain=[]; DPT_rain=DPT(minor_indi);
SR_rain=[]; SR_rain=SR(minor_indi);
Rain_rain=[]; Rain_rain=Rain(minor_indi);

major_indi=[]; major_indi=find(Rain==0);
PWV_norain=[]; PWV_norain=PWV(major_indi);
DOY_norain=[]; DOY_norain=DOY(major_indi);
Hour_norain=[]; Hour_norain=Hour(major_indi);
T_norain=[]; T_norain=T(major_indi);
RH_norain=[]; RH_norain=RH(major_indi);
DPT_norain=[]; DPT_norain=DPT(major_indi);
SR_norain=[]; SR_norain=SR(major_indi);
Rain_norain=[]; Rain_norain=Rain(major_indi);

mat_minor=[]; 
mat_minor(1,:)=DOY_rain; mat_minor(2,:)=Hour_rain; mat_minor(3,:)=T_rain; mat_minor(4,:)=SR_rain;
mat_minor(5,:)=RH_rain; mat_minor(6,:)=DPT_rain; mat_minor(7,:)=PWV_rain;
gr_minor=[]; gr_minor=Rain_rain';

mat_major=[]; Mat=[]; Gr=[]; 
indices_len=[]; indices_len=length(DOY_rain);
indices=[]; indices=datasample((1:length(DOY_norain)),indices_len,'Replace',false);
mat_major(1,:)=DOY_norain(indices); mat_major(2,:)=Hour_norain(indices); mat_major(3,:)=T_norain(indices); mat_major(4,:)=SR_norain(indices);
mat_major(5,:)=RH_norain(indices); mat_major(6,:)=DPT_norain(indices); mat_major(7,:)=PWV_norain(indices);
gr_major=[]; gr_major=Rain_norain(indices)';


Mat=[mat_minor, mat_major];
Gr=[gr_minor, gr_major];

% Normalizing the Data 
X_matrix=[]; X_matrix=Mat';
Norm_Mat=[];
for k=1:7
   t=[]; t=X_matrix(:,k);
   m=[]; m=mean(t);
   temp=[]; temp=(t-m)./std(t);
   Norm_Mat(:,k)=temp;   
end

% PCA 
coeff=[]; score=[]; latent=[]; explained=[]; 
[coeff,score,latent,explained] = pca(Norm_Mat);

% Calculating the covariance matrix 
covMat=[]; covMat = cov(Norm_Mat);
Ve=[]; [Ve, ~] = eig(covMat);

% Relative loadings (co-efficients for the input variables)
p=[]; p = Ve(:,end:-1:1);


% Plotting the biplot
figure(1)
X=[]; X = Norm_Mat;
[coefs,score] = pca(X);
vlabs = {'DoY','ToD','T','SR','RH','DPT','PWV'};
biplot(coefs(:,1:2), 'scores',score(:,1:2), 'varlabels',vlabs,'Positive',false);
xlabel('Principal Component 1','FontName','Times','FontSize',12)
ylabel('Principal Component 2','FontName','Times','FontSize',12)
set(gca,'FontName','Times','FontSize',12)


% Plotting the scores 
figure(2)
p1=[]; p1=score(:,1);
p2=[]; p2=score(:,2);

f=[]; f=find(Gr>0);
plot(p1(f),p2(f),'ob');
hold on;
inid=[]; indi=1:length(Gr);
indices=[]; indices=indi;
indices(f)=[];
plot(p1(indices),p2(indices),'.g');
xlabel('Principal Component 1','FontName','Times','FontSize',12)
ylabel('Principal Component 2','FontName','Times','FontSize',12)
set(gca,'FontName','Times','FontSize',12);
legend('Rain Cases','No Rain Cases')



