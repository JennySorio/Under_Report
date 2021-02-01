stationarityB = zeros(2*3,4);

%%%% By Hosp

meanHospByGender = [0.0529813266056450 0.0504573252869228;0.00798559086996717 0.0110205276400688;0.160645161290323 0.212121212121212];
HospByGenderCI90 = [0.0415584415584416 0.0596458527493010;0.0376068376068376 0.0629699248120301;0.00457038391224863 0.0121951219512195;0.00839630562552477 0.0165369649805447;0.0862068965517241 0.235294117647059;0.152777777777778 0.361702127659574];
day = 1;

%%%% Female
CorrByGender = zeros(size(dataC1,1)-day,2);
CorrNumCasesByGender = dataC1(:,end-2:end-1);
CorrByGender(:,1) = ...
         max(1,min(1,dataH1(1+day:end,end-2)./dataC1(1:end-day,end-2))/meanHospByGender(1,1));
CorrNumCasesByGender(1:end-day,1) = ...
         CorrNumCasesByGender(1:end-day,1).*CorrByGender(:,1);
%%%% Confidence Intervals
CorrByGenderCI = zeros(size(dataC1,1)-day,4);
CorrNumCasesByGenderCI = zeros(size(dataC1,1),4);
CorrNumCasesByGenderCI(:,1) = dataC1(:,end-2);
CorrByGenderCI(:,1) = ...
         max(1,min(1,dataH1(1+day:end,end-2)./dataC1(1:end-day,end-2))/HospByGenderCI90(1,1));
CorrNumCasesByGenderCI(1:end-day,1) = ...
         CorrNumCasesByGenderCI(1:end-day,1).*CorrByGenderCI(:,1);
CorrNumCasesByGenderCI(:,3) = dataC1(:,end-2);     
CorrByGenderCI(:,3) = ...
         max(1,min(1,dataH1(1+day:end,end-2)./dataC1(1:end-day,end-2))/HospByGenderCI90(1,2));
CorrNumCasesByGenderCI(1:end-day,3) = ...
         CorrNumCasesByGenderCI(1:end-day,3).*CorrByGenderCI(:,3);

%%%%% Male
CorrByGender(:,2) = ...
         max(1,min(1,dataH1(1+day:end,end-1)./dataC1(1:end-day,end-1))/meanHospByGender(1,2));
CorrNumCasesByGender(1:end-day,2) = ...
         CorrNumCasesByGender(1:end-day,2).*CorrByGender(:,2);

%%%%% Confidence Intervals
CorrNumCasesByGenderCI(:,2) = dataC1(:,end-1);
CorrByGenderCI(:,2) = ...
         max(1,min(1,dataH1(1+day:end,end-1)./dataC1(1:end-day,end-1))/HospByGenderCI90(2,1));
CorrNumCasesByGenderCI(1:end-day,2) = ...
         CorrNumCasesByGenderCI(1:end-day,2).*CorrByGenderCI(:,2);
CorrNumCasesByGenderCI(:,4) = dataC1(:,end-1);     
CorrByGenderCI(:,4) = ...
         max(1,min(1,dataH1(1+day:end,end-1)./dataC1(1:end-day,end-1))/HospByGenderCI90(2,2));
CorrNumCasesByGenderCI(1:end-day,4) = ...
         CorrNumCasesByGenderCI(1:end-day,4).*CorrByGenderCI(:,4);

%%%%%%%%%%By Death Rate
day = 12;
%%%% Female
CorrByGenderD = zeros(size(dataC1,1)-day,2);
CorrNumCasesByGenderD = dataC1(:,end-2:end-1);
CorrByGenderD(:,1) = ...
         max(1,min(1,dataD1(1+day:end,end-2)./dataC1(1:end-day,end-2))/meanHospByGender(2,1));
CorrNumCasesByGenderD(1:end-day,1) = ...
         CorrNumCasesByGenderD(1:end-day,1).*CorrByGenderD(:,1);
%%%% Confidence Intervals
CorrByGenderDCI = zeros(size(dataC1,1)-day,4);
CorrNumCasesByGenderDCI = zeros(size(dataC1,1),4);
CorrNumCasesByGenderDCI(:,1) = dataC1(:,end-2);
CorrByGenderDCI(:,1) = ...
         max(1,min(1,dataD1(1+day:end,end-2)./dataC1(1:end-day,end-2))/HospByGenderCI90(3,1));
CorrNumCasesByGenderDCI(1:end-day,1) = ...
         CorrNumCasesByGenderDCI(1:end-day,1).*CorrByGenderDCI(:,1);
CorrNumCasesByGenderDCI(:,3) = dataC1(:,end-2);     
CorrByGenderDCI(:,3) = ...
         max(1,min(1,dataD1(1+day:end,end-2)./dataC1(1:end-day,end-2))/HospByGenderCI90(3,2));
CorrNumCasesByGenderDCI(1:end-day,3) = ...
         CorrNumCasesByGenderDCI(1:end-day,3).*CorrByGenderDCI(:,3);

%%%%% Male
CorrByGenderD(:,2) = ...
         max(1,min(1,dataD1(1+day:end,end-1)./dataC1(1:end-day,end-1))/meanHospByGender(2,2));
CorrNumCasesByGenderD(1:end-day,2) = ...
         CorrNumCasesByGenderD(1:end-day,2).*CorrByGenderD(:,2);

%%%%% Confidence Intervals
CorrNumCasesByGenderDCI(:,2) = dataC1(:,end-1);
CorrByGenderDCI(:,2) = ...
         max(1,min(1,dataD1(1+day:end,end-1)./dataC1(1:end-day,end-1))/HospByGenderCI90(4,1));
CorrNumCasesByGenderDCI(1:end-day,2) = ...
         CorrNumCasesByGenderDCI(1:end-day,2).*CorrByGenderDCI(:,2);
CorrNumCasesByGenderDCI(:,4) = dataC1(:,end-1);     
CorrByGenderDCI(:,4) = ...
         max(1,min(1,dataD1(1+day:end,end-1)./dataC1(1:end-day,end-1))/HospByGenderCI90(4,2));
CorrNumCasesByGenderDCI(1:end-day,4) = ...
         CorrNumCasesByGenderDCI(1:end-day,4).*CorrByGenderDCI(:,4);
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
box on
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesByGenderCI(:,1:2),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByGenderCI(:,3:4),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByGender,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsGender_MX.fig');
print('-dpng','InfectionsGender_MX');
end


figure
hold on
box on
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesByGenderDCI(:,1:2),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByGenderDCI(:,3:4),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByGenderD,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsGenderD_MX.fig');
print('-dpng','InfectionsGenderD_MX');
end


disp(['Hosp          ',num2str(round([sum(sum(CorrNumCasesByGender(1:END,:),2)),sum(sum(CorrNumCasesByGenderCI(1:END,3:4),2)),sum(sum(CorrNumCasesByGenderCI(1:END,1:2),2))]))])
disp(['Death         ',num2str(round([sum(sum(CorrNumCasesByGenderD(1:END,:),2)),sum(sum(CorrNumCasesByGenderDCI(1:END,3:4),2)),sum(sum(CorrNumCasesByGenderDCI(1:END,1:2),2))]))])
disp(['Observed      ',num2str(sum(data(1:END,end)))])

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
