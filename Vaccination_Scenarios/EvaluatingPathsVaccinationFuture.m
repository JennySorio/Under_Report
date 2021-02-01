clear all; clc; close all; format long e;
load dataChicago_20201129_Asympt;

ndays = 43;
l=3;
t_actual2 = 0:length(t_actual)-l+ndays;

%%%% Population proportion on each age range:
% aux = 0.97*0.01*ones(size(t_acual));
Vaccination = zeros(size(t_actual2));
Vaccination(t_actual2>=230) = 0.97*0.01*ones;
params.VaccinationRate = @(t)interp1(t_actual2,Vaccination,t);

Death = ones(size(t_actual2));
Death(3:length(t_actual)) = min(1,data1(2:end,2)./data1(1:end-1,3))/Death_I;
Death(length(t_actual)+1:end) = mean(Death(length(t_actual)-l-9:length(t_actual)-l))*ones;
params.factorDeath = @(t)interp1(t_actual2,Death,t);


EvaluatingPathsFuture;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluating BootVacstrap predictions

Number = NumberOfAgeClasses;


TotalHospBootVac = zeros(Number,NSamples); 
TotalInfectionsBootVac = zeros(Number,NSamples);
TotalDeathsBootVac = zeros(Number,NSamples);

Vaccinates = zeros(length(t_actual2),NSamples); 
NewCasesBootVac = zeros(length(t_actual2),NSamples);
NewDeathsBootVac = zeros(length(t_actual2),NSamples);
NewHospBootVac = zeros(length(t_actual2),NSamples);


parfor ll = 1:NSamples
params2 = params;
p = params2.p;
Hosp = Hosp95(ll)*ones(length(t_actual2),1);
% Hosp(1:end-4) = min(1,Hospitalization./trajectories(1:size(trajectories,1)-4,ll));
Hosp = min(20,Hosp/GetWorse_M);
params2.factorWorse = @(t)interp1(t_actual2,Hosp,t);

% %%% Estimating the transmission constant parameters (M,H,I), the initial
% %%% infecve population (I_M0) and the transmission matrix:
yinitB = yinitOld;
I_M = PARAMS1Boot(ll,1);

yinitB = zeros(1,9*Number);
for jj = 3:9
yinitB((jj-1)*Number+1:jj*Number) = yinit((jj-2)*Number+1:(jj-1)*Number);
end
yinitB(Number+1:2*Number) = zeros;
yinitB(3*Number+1:4*Number) = (1-p)*I_M*PropInfections;
yinitB(4*Number+1:5*Number) = p*I_M*PropInfections;
yinitB(1:Number) = Proportion-I_M*PropInfections;
params2.a = PARAMS1Boot(ll,2);
params2.b = PARAMS1Boot(ll,3);
params2.c = PARAMS1Boot(ll,4);

Beta = BETABoot(ll,:);
Beta2 = [Beta(1:end-l),mean(Beta(end-l-9:end-l))*ones(1,ndays+1)];
beta2 = @(t)interp1(t_actual2,Beta2,t);
yinit2 = yinitB;
yb2 = zeros(length(t_actual2),9*Number);
yb2(1,:) = yinitB;
auxA = zeros(1,length(Beta2)-1);
for jj =1:day-1
t_actualB = t_actual2(jj:jj+1);
% beta2 = @(t)interp1(t_actualB,Beta2(jj:jj+1),t);
[~,y2B] = ode45(@(t,y)seir_Vaccination(t,y,params2,beta2),...
                                                 t_actualB,yinit2,options);
yinit2 = y2B(end,:);
yb2(jj+1,:) = yinit2;
end

for ss = 1:nmax-1

if ss == nmax-1
aux = (day-1)+(ss-1)*dt+1:length(t_actual2)-1;
aux2 = (day-1)+(ss-1)*dt+1:length(t_actual2);    
else
aux = (day-1)+(ss-1)*dt+1:(day-1)+ss*dt;
aux2 = (day-1)+(ss-1)*dt+1:(day-1)+ss*dt+1;
end
params2.a = PARAMS2Boot(ss,1,ll);
params2.b = PARAMS2Boot(ss,2,ll);
params2.c = PARAMS2Boot(ss,3,ll);

for jj = aux
t_actualB = t_actual2(jj:jj+1);
% beta2 = @(t)interp1(t_actualB,Beta2(jj:jj+1),t);
[~,y2] = ode45(@(t,y)seir_Vaccination(t,y,params2,beta2),...
                                                 t_actualB,yinit2,options);
yinit2 = y2(end,:);
yb2(jj+1,:) = yinit2;
end
end
NewCasesBootVac(:,ll) = ...
    sigma*sum(yb2(:,2*Number+1:3*Number),2);
Vaccinated(:,ll) = ...
    Vaccination'.*sum(yb2(:,1:Number),2);

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

aux = sort(Vaccinated');
aux2 = round(0*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95Vac = [min(aux);max(aux)]*N;

%%% New Cases:
aux = sort(NewCasesBoot');
aux2 = round(0*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewCases = [min(aux);max(aux)]*N;

%%% New Deaths:
aux = sort(NewDeathsBoot');
aux2 = round(0.05*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewDeaths = [min(aux);max(aux)]*N;

%%% New Hospitalizations:
aux = sort(NewHospBoot');
aux2 = round(0.05*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewHosp = [min(aux);max(aux)]*N;

%%% New Cases:
aux = sort(NewCasesBootVac');
aux2 = round(0*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewCasesVac = [min(aux);max(aux)]*N;

%%% New Deaths:
aux = sort(NewDeathsBootVac');
aux2 = round(0.05*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewDeathsVac = [min(aux);max(aux)]*N;

%%% New Hospitalizations:
aux = sort(NewHospBootVac');
aux2 = round(0.05*NSamples);
aux = aux(aux2+1:end-aux2,:);
CI95NewHospVac = [min(aux);max(aux)]*N;

H = [100 100 600 300];
%%% plotting Results:
figure
hold on
% grid on
box on
title('Daily Infections - Chicago')
h1=area(t_span,CI95NewCases(2,:),'linestyle',':','FaceColor',[255,160,122]/255,'FaceAlpha',1);%[51,236,255]/255);
h2=area(t_span,CI95NewCases(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
h1=area(t_span,CI95NewCasesVac(2,:),'linestyle',':','FaceColor',[51,236,255]/255,'FaceAlpha',0.3);
h2=area(t_span,CI95NewCasesVac(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span,median(NewCasesBoot*N,2),'r','LineWidth',2)
% plot(t_span(2:end),data1(:,1),'r','LineWidth',2)
plot(t_span,median(NewCasesBootVac*N,2),'b','LineWidth',2)
legend('Without Vaccination','With Vaccination','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(220),t_span(end)])
h1=plot([t_span(230),t_span(230)],[0,2*max(median(NewCasesBoot(220:end,:)*N,2))],'k','LineWidth',1);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
ylim([0,2*max(median(NewCasesBoot(220:end,:)*N,2))])
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
saveas(gcf,'InfectionsChicagoVac2.fig');
print('-dpng','InfectionsChicagoVac2');

figure
hold on
% grid on
box on
title('Daily Deaths - Chicago')
h1=area(t_span,CI95NewDeaths(2,:),'linestyle',':','FaceColor',[255,160,122]/255);
h2=area(t_span,CI95NewDeaths(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
h1=area(t_span,CI95NewDeathsVac(2,:),'linestyle',':','FaceColor',[51,236,255]/255);
h2=area(t_span,CI95NewDeathsVac(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span,median(NewDeathsBoot*N,2),'r','LineWidth',2)
% plot(t_span(2:end),data1(:,2),'r','LineWidth',2)
plot(t_span,median(NewDeathsBootVac*N,2),'b','LineWidth',2)
legend('Without Vaccination','With Vaccination','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(220),t_span(end)])
h1=plot([t_span(230),t_span(230)],[0,1.3*max(median(NewDeathsBoot(220:end,:)*N,2))],'k','LineWidth',1);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
ylim([0,1.3*max(median(NewDeathsBoot(220:end,:)*N,2))])
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
saveas(gcf,'DeathsChicagoVac2.fig');
print('-dpng','DeathsChicagoVac2');

%%%%%%%%%
figure
hold on
% grid on
box on
title('Daily Hospitalizations - Chicago')
h1=area(t_span,CI95NewHosp(2,:),'linestyle',':','FaceColor',[255,160,122]/255);
h2=area(t_span,CI95NewHosp(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
h1=area(t_span,CI95NewHospVac(2,:),'linestyle',':','FaceColor',[51,236,255]/255);
h2=area(t_span,CI95NewHospVac(1,:),'linestyle',':','FaceColor',[1,1,1]);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
plot(t_span,median(NewHospBoot*N,2),'r','LineWidth',2)
% plot(t_span(2:end),data1(:,3),'r','LineWidth',2)
plot(t_span,median(NewHospBootVac*N,2),'b','LineWidth',2)
legend('Without Vaccination','With Vaccination','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(220),t_span(end)])
h1=plot([t_span(230),t_span(230)],[0,1.3*max(median(NewHospBoot(220:end,:)*N,2))],'k','LineWidth',1);
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
ylim([0,1.3*max(median(NewHospBoot(220:end,:)*N,2))])
xtickformat('dd-MMM')
set(gcf,'Position',H)
set(gca,'FontSize',16,'FontName','Arial')
hold off
saveas(gcf,'HospChicagoVac2.fig');
print('-dpng','HospChicagoVac2');

disp(['Vaccinated: ',num2str(round([sum(median(N*Vaccinated(230:end,:),2)),sum(CI95Vac(1,230:end)),sum(CI95Vac(2,230:end))]))])

disp(['With Vaccination: ',num2str(round([sum(median(N*NewCasesBootVac(230:end,:),2)),sum(CI95NewCasesVac(1,230:end)),sum(CI95NewCasesVac(2,230:end))]))])
disp(['Without Vaccination: ',num2str(round([sum(median(N*NewCasesBoot(230:end,:),2)),sum(CI95NewCases(1,230:end)),sum(CI95NewCases(2,230:end))]))])
% disp(['Without Vaccination: ',num2str(round(sum(data1(230:end,1))))])

disp(['With Vaccination: ',num2str(round([sum(median(N*NewHospBootVac(230:end,:),2)),sum(CI95NewHospVac(1,230:end)),sum(CI95NewHospVac(2,230:end))]))])
disp(['Without Vaccination: ',num2str(round([sum(median(N*NewHospBoot(230:end,:),2)),sum(CI95NewHosp(1,230:end)),sum(CI95NewHosp(2,230:end))]))])
% disp(['Without Vaccination: ',num2str(round(sum(data1(230:end,3))))])

disp(['With Vaccination: ',num2str(round([sum(median(N*NewDeathsBootVac(230:end,:),2)),sum(CI95NewDeathsVac(1,230:end)),sum(CI95NewDeathsVac(2,230:end))]))])
disp(['Without Vaccination: ',num2str(round([sum(median(N*NewDeathsBoot(230:end,:),2)),sum(CI95NewDeaths(1,230:end)),sum(CI95NewDeaths(2,230:end))]))])
% disp(['Without Vaccination: ',num2str(round(sum(data1(230:end,2))))])