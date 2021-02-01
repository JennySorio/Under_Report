stationarityB = zeros(2*3,4);

%%%% By Hosp
day = 1;
MeanHospByGender = zeros(3,2);
HospByGenderCI90 = zeros(2*3,2);
aux = data1(1+day:end,49)./data1(1:end-day,13);
aux = aux(inicio:fim);

if AutoCorr == 1
figure
autocorr(aux)
end

MeanHospByGender(1,1) = median(aux);
stationarityB(1,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(1,:) = [min(aux),max(aux)];



aux = data1(1+day:end,50)./data1(1:end-day,14);
aux = aux(inicio:fim);
MeanHospByGender(1,2) = median(aux);

if AutoCorr == 1
figure
autocorr(aux)
end

stationarityB(2,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(2,:) = [min(aux),max(aux)];


%%%% By Death
day = 12;
aux = data1(1+day:end,31)./data1(1:end-day,13);
aux = aux(inicio:fim);

if AutoCorr == 1
figure
autocorr(aux)
end

MeanHospByGender(2,1) = median(aux);
stationarityB(3,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(3,:) = [min(aux),max(aux)];



aux = data1(1+day:end,32)./data1(1:end-day,14);
aux = aux(inicio:fim);
MeanHospByGender(2,2) = median(aux);

if AutoCorr == 1
figure
autocorr(aux)
end

stationarityB(4,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(4,:) = [min(aux),max(aux)];


%%%% By Death in Hosp
day = 11;
aux = data1(1+day:end,31)./data1(1:end-day,49);
aux = aux(inicio:fim);

if AutoCorr == 1
figure
autocorr(aux)
end

MeanHospByGender(3,1) = median(aux);
stationarityB(5,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(5,:) = [min(aux),max(aux)];



aux = data1(1+day:end,32)./data1(1:end-day,50);
aux = aux(inicio:fim);
MeanHospByGender(3,2) = median(aux);

if AutoCorr == 1
figure
autocorr(aux)
end

stationarityB(6,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
HospByGenderCI90(6,:) = [min(aux),max(aux)];
disp('Female')
disp([['Hosp          ';'Death         ';'Death in Hosp '],num2str(100*[MeanHospByGender(:,1),HospByGenderCI90(1:2:end,:)])])
disp('Male')
disp([['Hosp          ';'Death         ';'Death in Hosp '],num2str(100*[MeanHospByGender(:,2),HospByGenderCI90(2:2:end,:)])])
% disp([['Hosp          ';'Death         ';'Death in Hosp '],num2str(stationarityB)])
disp(num2str(stationarityB))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% day = 1;
% figure
% hold on
% % grid on
% box on
% title('Hospitalization Rate by Gender')
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,49)./data1(1:end-day,13)),'r','LineWidth',1)
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,50)./data1(1:end-day,14)),'--b','LineWidth',1)
% % plot(t_span(1:end),100*MeanHosp*ones(size(t_span(1:end))),'k')
% area([t_span(inicio),t_span(fim)],[90,90],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
% ylabel('Daily Percentage (%)')
% legend('Female','Male')
% xlim([t_span(2+day),t_span(end)])
% ylim([0,20])
% xtickformat('dd-MMM')
% set(gca,'FontSize',16,'FontName','Arial')
% set(gcf,'Position',[100 100 600 H])
% hold off
% if SaveFig == 1
% saveas(gcf,'HospRateGender_Chicago.fig');
% print('-dpng','HospRateGender_Chicago');
% end
% 
% day = 12;
% figure
% hold on
% % grid on
% box on
% title('Death Rate by Gender')
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,31)./data1(1:end-day,13)),'r','LineWidth',1)
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,32)./data1(1:end-day,14)),'--b','LineWidth',1)
% % plot(t_span(1:end),100*MeanHosp*ones(size(t_span(1:end))),'k')
% area([t_span(inicio),t_span(fim)],[90,90],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
% ylabel('Daily Percentage (%)')
% legend('Female','Male')
% xlim([t_span(2+day),t_span(end)])
% ylim([0,20])
% xtickformat('dd-MMM')
% set(gca,'FontSize',16,'FontName','Arial')
% set(gcf,'Position',[100 100 600 H])
% hold off
% if SaveFig == 1
% saveas(gcf,'DeathRateGender_Chicago.fig');
% print('-dpng','DeathRateGender_Chicago');
% end
% 
% day = 11;
% figure
% hold on
% % grid on
% box on
% title('Death Rate in Hospital by Gender')
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,31)./data1(1:end-day,49)),'r','LineWidth',1)
% plot(t_span(2+day:end),100*min(1,data1(1+day:end,32)./data1(1:end-day,50)),'--b','LineWidth',1)
% % plot(t_span(1:end),100*MeanHosp*ones(size(t_span(1:end))),'k')
% area([t_span(inicio),t_span(fim)],[90,90],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
% ylabel('Daily Percentage (%)')
% legend('Female','Male','Location','NorthWest')
% xlim([t_span(2+day),t_span(end)])
% ylim([0,90])
% xtickformat('dd-MMM')
% set(gca,'FontSize',16,'FontName','Arial')
% set(gcf,'Position',[100 100 600 H])
% hold off
% if SaveFig == 1
% saveas(gcf,'DeathInHospRateGender_Chicago.fig');
% print('-dpng','DeathInHospRateGender_Chicago');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% By Hospitalization
day = 1;
%%%% Female
CorrByGender = zeros(size(data1,1)-day,2);
CorrNumCasesByGender = data1(:,13:14);
CorrByGender(:,1) = ...
         max(1,min(1,data1(1+day:end,49)./data1(1:end-day,13))/MeanHospByGender(1,1));
CorrNumCasesByGender(1:end-day,1) = ...
         CorrNumCasesByGender(1:end-day,1).*CorrByGender(:,1);
%%%% Confidence Intervals
CorrByGenderCI = zeros(size(data1,1)-day,4);
CorrNumCasesByGenderCI = zeros(size(data1,1),4);
CorrNumCasesByGenderCI(:,1) = data1(:,13);
CorrByGenderCI(:,1) = ...
         max(1,min(1,data1(1+day:end,49)./data1(1:end-day,13))/HospByGenderCI90(1,1));
CorrNumCasesByGenderCI(1:end-day,1) = ...
         CorrNumCasesByGenderCI(1:end-day,1).*CorrByGenderCI(:,1);
CorrNumCasesByGenderCI(:,3) = data1(:,13);     
CorrByGenderCI(:,3) = ...
         max(1,min(1,data1(1+day:end,49)./data1(1:end-day,13))/HospByGenderCI90(1,2));
CorrNumCasesByGenderCI(1:end-day,3) = ...
         CorrNumCasesByGenderCI(1:end-day,3).*CorrByGenderCI(:,3);

%%%%% Male
CorrByGender(:,2) = ...
         max(1,min(1,data1(1+day:end,50)./data1(1:end-day,14))/MeanHospByGender(1,2));
CorrNumCasesByGender(1:end-day,2) = ...
         CorrNumCasesByGender(1:end-day,2).*CorrByGender(:,2);

%%%%% Confidence Intervals
CorrNumCasesByGenderCI(:,2) = data1(:,14);
CorrByGenderCI(:,2) = ...
         max(1,min(1,data1(1+day:end,50)./data1(1:end-day,14))/HospByGenderCI90(2,1));
CorrNumCasesByGenderCI(1:end-day,2) = ...
         CorrNumCasesByGenderCI(1:end-day,2).*CorrByGenderCI(:,2);
CorrNumCasesByGenderCI(:,4) = data1(:,14);     
CorrByGenderCI(:,4) = ...
         max(1,min(1,data1(1+day:end,50)./data1(1:end-day,14))/HospByGenderCI90(2,2));
CorrNumCasesByGenderCI(1:end-day,4) = ...
         CorrNumCasesByGenderCI(1:end-day,4).*CorrByGenderCI(:,4);

%%%%%%%%%%By Death Rate
day = 12;
%%%% Female
CorrByGenderD = zeros(size(data1,1)-day,2);
CorrNumCasesByGenderD = data1(:,13:14);
CorrByGenderD(:,1) = ...
         max(1,min(1,data1(1+day:end,31)./data1(1:end-day,13))/MeanHospByGender(2,1));
CorrNumCasesByGenderD(1:end-day,1) = ...
         CorrNumCasesByGenderD(1:end-day,1).*CorrByGenderD(:,1);
%%%% Confidence Intervals
CorrByGenderDCI = zeros(size(data1,1)-day,4);
CorrNumCasesByGenderDCI = zeros(size(data1,1),4);
CorrNumCasesByGenderDCI(:,1) = data1(:,13);
CorrByGenderDCI(:,1) = ...
         max(1,min(1,data1(1+day:end,31)./data1(1:end-day,13))/HospByGenderCI90(3,1));
CorrNumCasesByGenderDCI(1:end-day,1) = ...
         CorrNumCasesByGenderDCI(1:end-day,1).*CorrByGenderDCI(:,1);
CorrNumCasesByGenderDCI(:,3) = data1(:,13);     
CorrByGenderDCI(:,3) = ...
         max(1,min(1,data1(1+day:end,31)./data1(1:end-day,13))/HospByGenderCI90(3,2));
CorrNumCasesByGenderDCI(1:end-day,3) = ...
         CorrNumCasesByGenderDCI(1:end-day,3).*CorrByGenderDCI(:,3);

%%%%% Male
CorrByGenderD(:,2) = ...
         max(1,min(1,data1(1+day:end,32)./data1(1:end-day,14))/MeanHospByGender(2,2));
CorrNumCasesByGenderD(1:end-day,2) = ...
         CorrNumCasesByGenderD(1:end-day,2).*CorrByGenderD(:,2);

%%%%% Confidence Intervals
CorrNumCasesByGenderDCI(:,2) = data1(:,14);
CorrByGenderDCI(:,2) = ...
         max(1,min(1,data1(1+day:end,32)./data1(1:end-day,14))/HospByGenderCI90(4,1));
CorrNumCasesByGenderDCI(1:end-day,2) = ...
         CorrNumCasesByGenderDCI(1:end-day,2).*CorrByGenderDCI(:,2);
CorrNumCasesByGenderDCI(:,4) = data1(:,14);     
CorrByGenderDCI(:,4) = ...
         max(1,min(1,data1(1+day:end,32)./data1(1:end-day,14))/HospByGenderCI90(4,2));
CorrNumCasesByGenderDCI(1:end-day,4) = ...
         CorrNumCasesByGenderDCI(1:end-day,4).*CorrByGenderDCI(:,4);
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
box on
title('Daily Infections - Chicago')
h1=area(t_span(2:end),sum(CorrNumCasesByGenderCI(:,1:2),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByGenderCI(:,3:4),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),sum(data1(:,13:14),2),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByGender,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
area([t_span(2),t_span(inicio)],[5000,5000],'FaceAlpha',0.3,'FaceColor',[249,208,160]/255,'linestyle',':')
area([t_span(inicio),t_span(fim)],[5000,5000],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
area([t_span(fim),t_span(end)],[5000,5000],'FaceAlpha',0.3,'FaceColor',[193,253,199]/255,'linestyle',':')
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsGender_Chicago.fig');
print('-dpng','InfectionsGender_Chicago');
end


figure
hold on
box on
title('Daily Infections - Chicago')
h1=area(t_span(2:end),sum(CorrNumCasesByGenderDCI(:,1:2),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByGenderDCI(:,3:4),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),data1(:,1),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByGenderD,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
area([t_span(2),t_span(inicio)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[249,208,160]/255,'linestyle',':')
area([t_span(inicio),t_span(fim)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
area([t_span(fim),t_span(end)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[193,253,199]/255,'linestyle',':')
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsGenderD_Chicago.fig');
print('-dpng','InfectionsGenderD_Chicago');
end


disp(['Hosp          ',num2str(round([sum(sum(CorrNumCasesByGender(1:END,:),2)),sum(sum(CorrNumCasesByGenderCI(1:END,3:4),2)),sum(sum(CorrNumCasesByGenderCI(1:END,1:2),2))]))])
disp(['Death         ',num2str(round([sum(sum(CorrNumCasesByGenderD(1:END,:),2)),sum(sum(CorrNumCasesByGenderDCI(1:END,3:4),2)),sum(sum(CorrNumCasesByGenderDCI(1:END,1:2),2))]))])
disp(['Observed      ',num2str(sum(data(1:END,1)))])

TotalCorrectedByGenderHosp = zeros(4,3);
TotalCorrectedByGenderDeath = zeros(4,3);

TotalCorrectedByGenderHosp(1,:) = [sum(sum(CorrNumCasesByGender(1:inicio-1,:),2)),sum(sum(CorrNumCasesByGenderCI(1:inicio-1,3:4),2)),sum(sum(CorrNumCasesByGenderCI(1:inicio-1,1:2),2))];
TotalCorrectedByGenderHosp(2,:) = [sum(sum(CorrNumCasesByGender(inicio:fim,:),2)),sum(sum(CorrNumCasesByGenderCI(inicio:fim,3:4),2)),sum(sum(CorrNumCasesByGenderCI(inicio:fim,1:2),2))];
TotalCorrectedByGenderHosp(3,:) = [sum(sum(CorrNumCasesByGender(fim+1:end,:),2)),sum(sum(CorrNumCasesByGenderCI(fim+1:end,3:4),2)),sum(sum(CorrNumCasesByGenderCI(fim+1:end,1:2),2))];
TotalCorrectedByGenderHosp(4,:) = sum(TotalCorrectedByGenderHosp(1:3,:));
% aux = [sum(CorrNumCasesByGender(fim+1:end),2),sum(CorrNumCasesByGenderCI(fim+1:end,3:4),2),sum(CorrNumCasesByGenderCI(fim+1:end,1:2),2)];
% plot(t_span(fim+1:end),aux(:,1),'r',t_span(fim+1:end),aux(:,1),':b',t_span(fim+1:end),aux(:,1),'--b')

TotalCorrectedByGenderDeath(1,:) = [sum(sum(CorrNumCasesByGenderD(1:inicio-1,:),2)),sum(sum(CorrNumCasesByGenderDCI(1:inicio-1,3:4),2)),sum(sum(CorrNumCasesByGenderDCI(1:inicio-1,1:2),2))];
TotalCorrectedByGenderDeath(2,:) = [sum(sum(CorrNumCasesByGenderD(inicio:fim,:),2)),sum(sum(CorrNumCasesByGenderDCI(inicio:fim,3:4),2)),sum(sum(CorrNumCasesByGenderDCI(inicio:fim,1:2),2))];
TotalCorrectedByGenderDeath(3,:) = [sum(sum(CorrNumCasesByGenderD(fim+1:end,:),2)),sum(sum(CorrNumCasesByGenderDCI(fim+1:end,3:4),2)),sum(sum(CorrNumCasesByGenderDCI(fim+1:end,1:2),2))];
TotalCorrectedByGenderDeath(4,:) = sum(TotalCorrectedByGenderDeath(1:3,:));
