meanHosp = 0.0520157035170360;
HospCI90 = [0.0395209580838323 0.0587419056429232];

%%%% Death
meanDeath = 0.00975727963285330;
DeathCI90 = [0.00667501042970380 0.0152887882219706];

day = 1;
figure
hold on
box on
title('Hospitalization Rate - Mexico City')
plot(t_span(2+day:end),100*min(1,dataH1(1+day:end,end)./dataC1(1:end-day,end)),'b');
ylabel('Daily Percentage (%)')
xlim([t_span(1),t_span(end)])
ylim([0,20])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'HospRate_MX.fig');
print('-dpng','HospRate_MX');
end

day = 12;
figure
hold on
box on
title('Death Rate - Mexico City')
plot(t_span(2+day:end),100*min(1,dataD1(1+day:end,end)./dataC1(1:end-day,end)),'b');
ylabel('Daily Percentage (%)')
xlim([t_span(1),t_span(end)])
ylim([0,10])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'DeathRate_MX.fig');
print('-dpng','DeathRate_MX');
end

day=11;
figure
hold on
box on
title('Death Rate in Hospital - Mexico City')
plot(t_span(2+day:end),100*min(1,dataD1(1+day:end,end)./dataH1(1:end-day,end)),'b');
ylabel('Daily Percentage (%)')
xlim([t_span(1),t_span(end)])
ylim([0,90])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'DeathInHospRate_MX.fig');
print('-dpng','DeathInHospRate_MX');
end

figure
hold on
% grid on
box on
title('Positive Tests - Mexico City')
plot(t_span(2:size(data2,1)+1),100*data2(:,2)./data2(:,1),'b');
plot(t_span(1:end),30*ones(size(t_span(1:end))),'k')
ylabel('Daily Percentage (%)')
xlim([t_span(2),t_span(size(data2,1)+1)])
ylim([0,50])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'PosRate_MX.fig');
print('-dpng','PosRate_MX');
end

figure
hold on
% grid on
box on
title('Tests - Mexico City')
plot(t_span(2:size(data2,1)+1),data2(:,1),'r','LineWidth',1)
plot(t_span(2:size(data2,1)+1),data2(:,2),'--b','LineWidth',1)
legend('Total','Positive','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(size(data2,1)+1)])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'Tests_MX.fig');
print('-dpng','Tests_MX');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Corrections

%%%%% By Hospitalizations
day = 1;
CorrTotal = max(1,min(1,dataH1(1+day:end,end)./dataC1(1:end-day,end))/meanHosp);
CorrTotalCI90A = max(1,min(1,dataH1(1+day:end,end)./dataC1(1:end-day,end))/HospCI90(1));
CorrTotalCI90B = max(1,min(1,dataH1(1+day:end,end)./dataC1(1:end-day,end))/HospCI90(2));

CorrNumCases = dataC1(:,end);
CorrNumCases(1:end-day) = CorrNumCases(1:end-day).*CorrTotal;

CorrNumCasesCI(:,1) = dataC1(:,end);
CorrNumCasesCI(1:end-day,1) = CorrNumCasesCI(1:end-day,1).*CorrTotalCI90A;
CorrNumCasesCI(:,2) = dataC1(:,end);
CorrNumCasesCI(1:end-day,2) = CorrNumCasesCI(1:end-day,2).*CorrTotalCI90B;

%%%%% By Death Rate
day = 12;
CorrTotalD = max(1,min(1,dataD1(1+day:end,end)./dataC1(1:end-day,end))/meanDeath);
CorrTotalDCI90A = max(1,min(1,dataD1(1+day:end,end)./dataC1(1:end-day,end))/DeathCI90(1));
CorrTotalDCI90B = max(1,min(1,dataD1(1+day:end,end)./dataC1(1:end-day,end))/DeathCI90(2));

CorrNumCasesD = dataC1(:,end);
CorrNumCasesD(1:end-day) = CorrNumCasesD(1:end-day).*CorrTotalD;

CorrNumCasesDCI(:,1) = dataC1(:,end);
CorrNumCasesDCI(1:end-day,1) = CorrNumCasesDCI(1:end-day,1).*CorrTotalDCI90A;
CorrNumCasesDCI(:,2) = dataC1(:,end);
CorrNumCasesDCI(1:end-day,2) = CorrNumCasesDCI(1:end-day,2).*CorrTotalDCI90B;

figure
hold on
box on
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesCI(:,1),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesCI(:,2),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),CorrNumCases,'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Reported','Corrected','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'Infections_MX.fig');
print('-dpng','Infections_MX');
end


figure
hold on
box on
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesDCI(:,1),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesDCI(:,2),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),CorrNumCasesD,'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Reported','Corrected','Location','NorthWest')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,10000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsD_MX.fig');
print('-dpng','InfectionsD_MX');
end

disp(['Hosp          ',num2str(round([sum(CorrNumCases(1:END)),sum(CorrNumCasesCI(1:END,2)),sum(CorrNumCasesCI(1:END,1))]))])
disp(['Death         ',num2str(round([sum(CorrNumCasesD(1:END)),sum(CorrNumCasesDCI(1:END,2)),sum(CorrNumCasesDCI(1:END,1))]))])
disp(['Death         ',num2str(sum(data(1:END,1)))])


TotalCorrectedHosp = zeros(4,3);
TotalCorrectedDeath = zeros(4,3);

TotalCorrectedHosp(1,:) = [sum(sum(CorrNumCases(1:inicio-1),2)),sum(sum(CorrNumCasesCI(1:inicio-1,2),2)),sum(sum(CorrNumCasesCI(1:inicio-1,1),2))];
TotalCorrectedHosp(2,:) = [sum(sum(CorrNumCases(inicio:fim),2)),sum(sum(CorrNumCasesCI(inicio:fim,2),2)),sum(sum(CorrNumCasesCI(inicio:fim,1),2))];
TotalCorrectedHosp(3,:) = [sum(sum(CorrNumCases(fim+1:end),2)),sum(sum(CorrNumCasesCI(fim+1:end,2),2)),sum(sum(CorrNumCasesCI(fim+1:end,1),2))];
TotalCorrectedHosp(4,:) = sum(TotalCorrectedHosp(1:3,:));

TotalCorrectedDeath(1,:) = [sum(sum(CorrNumCasesD(1:inicio-1),2)),sum(sum(CorrNumCasesDCI(1:inicio-1,2),2)),sum(sum(CorrNumCasesDCI(1:inicio-1,1),2))];
TotalCorrectedDeath(2,:) = [sum(sum(CorrNumCasesD(inicio:fim),2)),sum(sum(CorrNumCasesDCI(inicio:fim,2),2)),sum(sum(CorrNumCasesDCI(inicio:fim,1),2))];
TotalCorrectedDeath(3,:) = [sum(sum(CorrNumCasesD(fim+1:end),2)),sum(sum(CorrNumCasesDCI(fim+1:end,2),2)),sum(sum(CorrNumCasesDCI(fim+1:end,1),2))];
TotalCorrectedDeath(4,:) = sum(TotalCorrectedDeath(1:3,:));