clear all; clc; close all; format long e;
load dataChicago_20201129_Asympt;

ndays = 150;
l=3;
t_actual2 = 0:ndays;

%%%% Population proportion on each age range:



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluating BootVacstrap predictions
SizeOfInfections = 0.05:0.05:0.3;
NSamples = length(SizeOfInfections);

Number = NumberOfAgeClasses;
TotalHospBootVac = zeros(Number,NSamples); 
TotalInfectionsBootVac = zeros(Number,NSamples);
TotalDeathsBootVac = zeros(Number,NSamples);

Vaccinates = zeros(length(t_actual2),NSamples); 
NewCasesBootVac = zeros(length(t_actual2),NSamples);
NewDeathsBootVac = zeros(length(t_actual2),NSamples);
NewHospBootVac = zeros(length(t_actual2),NSamples);


Prop1 = [0.0700686842184481 0.0283111232939648 0.0123213347887258 0.00105520303035035 0.000583366886030090 0.869950040933671 0.0177102468488095];
Prop2 = [0.0714511800080811 0.0288697181811139 0.0125644418722692 0.887114659938536];
Effectiveness = (ones-SizeOfInfections)/0.95;
yinit = zeros(1,9);
for ll = 1:length(SizeOfInfections)
if ll == 1
yinit(3:end) = Prop1*SizeOfInfections(ll);
yinit(1) = ones - sum(yinit(3:end));
SUM = sum(yinit(3:end));
else
aux = [3,4,5,8];
yinit(aux) = Prop2*(SizeOfInfections(ll)-sum(yinit([6,7,9])));
yinit(1) = ones - sum(yinit(3:end));    
SUM2 = sum(yinit(3:end));
Effectiveness(ll) = ones-SUM2-SUM;
end
InitRecovered(ll) = yinit(end-1);
params2 = params;

Vaccination = zeros(size(t_actual2));
Vaccination(t_actual2>=2) = Effectiveness(ll)*0.9*0.005*ones;
params2.VaccinationRate = @(t)interp1(t_actual2,Vaccination,t);

p = params2.p;
Hosp = Effectiveness(ll)*0.051*ones(length(t_actual2),1);
Hosp = min(20,Hosp/GetWorse_M);
params2.factorWorse = @(t)interp1(t_actual2,Hosp,t);
GetWorse_H = 0.39;
params2.GetWorse_H = GetWorse_H;
Death = (0.18/0.39)*ones(length(t_actual2),1);
params2.factorDeath = @(t)interp1(t_actual2,Death,t);

% %%% Estimating the transmission constant parameters (M,H,I), the initial
% %%% infecve population (I_M0) and the transmission matrix:

params2.a = PARAMS2(end-1,1);
params2.b = PARAMS2(end-1,2);
params2.c = PARAMS2(end-1,3);

Beta2 = mean(BETA(end-l-9:end-l))*ones(1,length(t_actual2));
beta2 = @(t)interp1(t_actual2,Beta2,t);
yinit2 = yinit;
yb2 = zeros(length(t_actual2),9*Number);
yb2(1,:) = yinit2;
auxA = zeros(1,length(Beta2)-1);
for jj =1:length(t_actual2)-1
t_actualB = t_actual2(jj:jj+1);
[~,y2B] = ode45(@(t,y)seir_VaccinationB(t,y,params2,beta2),...
                                                 t_actualB,yinit2,options);
yinit2 = y2B(end,:);
yb2(jj+1,:) = yinit2;
end
Recovered(ll) = yb2(end,end-1);
VaccinatedB(ll) = yb2(end,2);
NewCasesBootVac(:,ll) = ...
    sigma*sum(yb2(:,2*Number+1:3*Number),2);
Vaccinated(:,ll) = ...
    Vaccination';


factor = zeros(length(t_actual2),1);
factorD = factor;
factorW = params2.factorWorse;
factorDeath = params2.factorDeath;
for jj = 1:length(t_actual2)
factor(jj) = factorW(t_actual2(jj));
factorD(jj) = factorDeath(t_actual2(jj));
end  

%%% Total Number of Deaths for each day
NewHospBb = zeros(size(yb2(:,1),1),Number);
Deathsb = zeros(length(yb2(:,1)),Number);

for jj=1:Number
NewDeathsBootVac(:,ll) = NewDeathsBootVac(:,ll)...
+ Death_M(jj)*yb2(:,4*Number+jj)...
+ Death_H(jj)*yb2(:,5*Number+jj)...
+ Death_I(jj)*factorD.*yb2(:,6*Number+jj);
NewHospBootVac(:,ll) = NewHospBootVac(:,ll)...
+ GetWorse_M(jj)*factor.*yb2(:,4*Number+jj);

NewHospBb(:,jj) = GetWorse_M(jj)*factor.*yb2(:,4*Number+jj);
Deathsb(:,jj) = Death_M(jj)*yb2(:,4*Number+jj)...
+Death_H(jj)*yb2(:,5*Number+jj)...
+Death_I(jj)*factorD.*yb2(:,6*Number+jj);
end

%%% Total Hospitalizations for each Age Range
TotalHospBootVac(:,ll) = sum(NewHospBb)'*N; 
TotalInfectionsBootVac(:,ll) = ...
      sum(params.sigma*yb(:,2*Number+1:3*Number))'*N;
TotalDeathsBootVac(:,ll) = sum(Deathsb)'*N;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_span = datetime(2020,3,01) + caldays(0:length(t_actual2)-1);


H = [100 100 600 300];
%%% plotting Results:
figure
hold on
box on
title('Daily Infections - Chicago')
plot(t_span,NewCasesBootVac*N)
ylabel('Number of Individuals')
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off

figure
hold on
box on
title('Daily Deaths - Chicago')
plot(t_span,NewDeathsBootVac*N)
ylabel('Number of Individuals')
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off


%%%%%%%%%
figure
hold on
box on
title('Daily Hospitalizations - Chicago')
plot(t_span,NewHospBootVac*N)%,'b','LineWidth',2)
ylabel('Number of Individuals')
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off


disp(['Vaccinated: ',num2str(round(N*VaccinatedB))])
disp(['Recovered: ',num2str(round(N*Recovered))])
disp(['Initial Recovered: ',num2str(round(N*InitRecovered))])
disp(['Recovered+Vaccinated: ',num2str(round(N*Recovered+N*VaccinatedB))])
disp(['Hospitalizations: ',num2str(round(N*sum(NewHospBootVac)))])
disp(['Deaths: ',num2str(round(N*sum(NewDeathsBootVac)))])