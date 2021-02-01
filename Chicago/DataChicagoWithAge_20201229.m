%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
day = 1;
stationarityC = zeros(8,4);

MeanHospByAge = zeros(1,8);
HospByAgeCI90 = zeros(8,2);
HospByAgeStd = zeros(8,2);
for jj = 1:8
aux = data1(1+day:end,39+jj)./data1(1:end-day,3+jj);
aux = aux(inicio:fim);
MeanHospByAge(jj) = median(aux);
HospByAgeStd(jj,:) = std(aux);
stationarityC(jj,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
% if jj == 1
% aux = aux(aux>0);
% end
HospByAgeCI90(jj,:) = [min(aux),max(aux)];
end

CorrByAge = zeros(size(data1,1)-day,8);
CorrByAgeCI = zeros(size(data1,1)-day,16);
CorrNumCasesByAge = data1(:,4:11);
CorrNumCasesByAgeCI = zeros(size(data1,1),16);
CorrNumCasesByAgeCI(:,1:2:end) = data1(:,4:11);
CorrNumCasesByAgeCI(:,2:2:end) = data1(:,4:11);
for jj = 1:8
if MeanHospByAge(jj)==0
CorrByAge(:,jj) = ones;
else
CorrByAge(:,jj) = ...
    max(1,min(1,data1(1+day:end,39+jj)./data1(1:end-day,3+jj))/MeanHospByAge(jj));
end
CorrNumCasesByAge(1:end-day,jj) = CorrNumCasesByAge(1:end-day,jj).*CorrByAge(:,jj);

if HospByAgeCI90(jj,1) == 0
CorrByAgeCI(:,(jj-1)*2+1) = ones;
else
CorrByAgeCI(:,(jj-1)*2+1) = ...
        max(1,min(1,data1(1+day:end,39+jj)./data1(1:end-day,3+jj))/HospByAgeCI90(jj,1));
end
CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+1) = ...
          CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+1).*CorrByAgeCI(:,(jj-1)*2+1);
if HospByAgeCI90(jj,2) == 0
CorrByAgeCI(:,(jj-1)*2+2) = ones;
else
CorrByAgeCI(:,(jj-1)*2+2) = ...
        max(1,min(1,data1(1+day:end,39+jj)./data1(1:end-day,3+jj))/HospByAgeCI90(jj,2));
end
CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+2) = ...
          CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+2).*CorrByAgeCI(:,(jj-1)*2+2);

end

%%%% Death
day = 12;

stationarityD = zeros(8,4);

MeanDeathByAge = zeros(1,8);
DeathByAgeCI90 = zeros(8,2);
for jj = 1:8
aux = data1(1+day:end,21+jj)./data1(1:end-day,3+jj);
aux = min(100,aux(inicio:fim));
aux = aux(isnan(aux)==0);
aux = aux(isinf(aux)==0);
MeanDeathByAge(jj) = median(aux);
stationarityD(jj,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
% if jj > 1
% aux = aux(aux>0);
% end
DeathByAgeCI90(jj,:) = [min(aux),max(aux)];
end

CorrByAgeD = zeros(size(data1,1)-day,8);
CorrByAgeDCI = zeros(size(data1,1)-day,16);
CorrNumCasesByAgeD = data1(:,4:11);
CorrNumCasesByAgeDCI = zeros(size(data1,1),16);
CorrNumCasesByAgeDCI(:,1:2:end) = data1(:,4:11);
CorrNumCasesByAgeDCI(:,2:2:end) = data1(:,4:11);
for jj = 1:8
if MeanDeathByAge(jj) == 0
CorrByAgeD(:,jj) = ones;%CorrByAge(:,jj);
else
CorrByAgeD(:,jj) = ...
    max(1,min(1,data1(1+day:end,21+jj)./data1(1:end-day,3+jj))/MeanDeathByAge(jj));
end
aux = CorrByAgeD(:,jj);
aux(aux==0)=ones;
CorrNumCasesByAgeD(1:end-day,jj) = CorrNumCasesByAgeD(1:end-day,jj).*aux;
if DeathByAgeCI90(jj,1) == 0
CorrByAgeDCI(:,(jj-1)*2+1) = CorrByAgeD(:,jj);%CorrByAgeCI(:,(jj-1)*2+1);
else
CorrByAgeDCI(:,(jj-1)*2+1) = ...
        max(1,min(1,data1(1+day:end,21+jj)./data1(1:end-day,3+jj))/DeathByAgeCI90(jj,1));
end
aux = CorrByAgeDCI(:,(jj-1)*2+1);
aux(aux==0)=ones;
CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+1) = ...
          CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+1).*aux;
if DeathByAgeCI90(jj,1) == 0
CorrByAgeDCI(:,(jj-1)*2+2) = ones;%CorrByAgeCI(:,(jj-1)*2+2);
else
CorrByAgeDCI(:,(jj-1)*2+2) = ...
        max(1,min(1,data1(1+day:end,21+jj)./data1(1:end-day,3+jj))/DeathByAgeCI90(jj,2));
end
aux = CorrByAgeDCI(:,(jj-1)*2+2);
aux(aux==0)=ones;
CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+2) = ...
          CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+2).*aux;
end


%%%% Death in Hospital
day = 11;
stationarityE = zeros(8,4);

MeanDeathInHospByAge = zeros(1,8);
DeathInHospByAgeCI90 = zeros(8,2);
for jj = 1:8
aux = data1(1+day:end,21+jj)./data1(1:end-day,39+jj);
aux = min(100,aux(inicio:fim));
aux = aux(isnan(aux)==0);
aux = aux(isinf(aux)==0);
MeanDeathInHospByAge(jj) = median(aux);
stationarityE(jj,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
% if jj > 1
% aux = aux(aux>0);
% end
DeathInHospByAgeCI90(jj,:) = [min(aux),max(aux)];
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
day = 1;
agerange = ['0-17  '
            '18-29 '
            '30-39 '
            '40-49 '
            '50-59 '
            '60-69 '
            '70-79 '
            '80+   '];
MAX = [25,25,25,40,40,40,80,80];
for jj = 1:8
figure
hold on
% grid on
box on
title(['Hospitalization Rate - Age ',agerange(jj,:)])
% for jj = 4:11
plot(t_span(2+day:end),100*min(1,data1(1+day:end,39+jj)./data1(1:end-day,3+jj)),'b','LineWidth',1)
plot(t_span(1:end),100*MeanHospByAge(jj)*ones(size(t_span(1:end))),'k')
area([t_span(inicio),t_span(fim)],[90,90],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
ylabel('Daily Percentage (%)')
xlim([t_span(2+day),t_span(end)])
ylim([0,MAX(jj)])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,['HospRateAge',num2str(jj),'_Chicago.fig']);
print('-dpng',['HospRateAge',num2str(jj),'_Chicago']);
end
end

day = 12;

MAX = [10,2.5,5,5,10,30,70,80];
for jj = 1:8
figure
hold on
% grid on
box on
title(['Death Rate - Age ',agerange(jj,:)])
% for jj = 4:11
plot(t_span(2+day:end),100*min(1,data1(1+day:end,21+jj)./data1(1:end-day,3+jj)),'b','LineWidth',1)
plot(t_span(1:end),100*MeanDeathByAge(jj)*ones(size(t_span(1:end))),'k')
area([t_span(inicio),t_span(fim)],[90,90],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
ylabel('Daily Percentage (%)')
xlim([t_span(2+day),t_span(end)])
ylim([0,MAX(jj)])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,['DeathRateAge',num2str(jj),'_Chicago.fig']);
print('-dpng',['DeathRateAge',num2str(jj),'_Chicago']);
end
end

day = 11;
MAX = [100,20,40,80,80,100,100,100];
for jj = 1:8
figure
hold on
% grid on
box on
title(['Death Rate in Hospital - Age ',agerange(jj,:)])
% for jj = 4:11
plot(t_span(2+day:end),100*min(1,data1(1+day:end,21+jj)./data1(1:end-day,39+jj)),'b','LineWidth',1)
plot(t_span(1:end),100*MeanDeathInHospByAge(jj)*ones(size(t_span(1:end))),'k')
area([t_span(inicio),t_span(fim)],[100,100],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
ylabel('Daily Percentage (%)')
xlim([t_span(2+day),t_span(end)])
ylim([0,MAX(jj)])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,['DeathInHospRateAge',num2str(jj),'_Chicago.fig']);
print('-dpng',['DeathInHospRateAge',num2str(jj),'_Chicago']);
end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Tests

% for jj = 1:8
% figure
% hold on
% box on
% title(['Rate of Positive Tests - Age ',agerange(jj,:)])
% % for jj = 4:11
% plot(t_span(2:end),100*min(1,data2(:,21+jj)./data2(:,3+jj)),'b','LineWidth',2)
% plot(t_span(1:end),10*ones(size(t_span(1:end))),'k')
% ylabel('Positive Tests (%)')
% xlim([t_span(1),t_span(end)])
% xtickformat('dd-MMM')
% set(gca,'FontSize',16,'FontName','Arial')
% set(gcf,'Position',[100 100 600 H])
% hold off
% if SaveFig == 1
% saveas(gcf,['PosRateAge',num2str(jj),'_Chicago.fig']);
% print('-dpng',['PosRateAge',num2str(jj),'_Chicago']);
% end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
% grid on
box on
title('Daily Infections - Chicago')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
% plot(t_span(2:end),data1(:,1),'r','LineWidth',1)
bar(t_span(2:end),data1(:,1),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAge,2),'b','LineWidth',2)
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
saveas(gcf,'InfectionsAge_Chicago.fig');
print('-dpng','InfectionsAge_Chicago');
end

figure
hold on
% grid on
box on
title('Daily Infections - Chicago')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
% plot(t_span(2:end),data1(:,1),'r','LineWidth',1)
bar(t_span(2:end),data1(:,1),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAgeD,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
area([t_span(2),t_span(inicio)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[249,208,160]/255,'linestyle',':')
area([t_span(inicio),t_span(fim)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
area([t_span(fim),t_span(end)],[10000,10000],'FaceAlpha',0.3,'FaceColor',[193,253,199]/255,'linestyle',':')
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
ylim([0,10000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsAgeD_Chicago.fig');
print('-dpng','InfectionsAgeD_Chicago');
end

disp('Chicago (Hosp. Rate):')
disp([agerange,num2str(100*[MeanHospByAge',HospByAgeCI90])])
disp([agerange,num2str(stationarityC)])

disp('Chicago (Death Rate):')
disp([agerange,num2str(100*[MeanDeathByAge',DeathByAgeCI90])])
disp([agerange,num2str(stationarityD)])

disp('Chicago (Death Rate in Hosp):')
disp([agerange,num2str(100*[MeanDeathInHospByAge',DeathInHospByAgeCI90])])
disp([agerange,num2str(stationarityE)])

ResultsAge = 100*[MeanHospByAge',HospByAgeCI90,MeanDeathByAge',DeathByAgeCI90,MeanDeathInHospByAge',DeathInHospByAgeCI90];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(num2str(round([sum(sum(CorrNumCasesByAge(1:END,:),2)),sum(sum(CorrNumCasesByAgeCI(1:END,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(1:END,1:2:end),2))])))
disp(num2str(round(sum(data1(1:END,1)))))

TotalCorrectedByAgeHosp = zeros(4,3);
TotalCorrectedByAgeDeath = zeros(4,3);

TotalCorrectedByAgeHosp(1,:) = [sum(sum(CorrNumCasesByAge(1:inicio-1,:),2)),sum(sum(CorrNumCasesByAgeCI(1:inicio-1,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(1:inicio-1,1:2:end),2))];
TotalCorrectedByAgeHosp(2,:) = [sum(sum(CorrNumCasesByAge(inicio:fim,:),2)),sum(sum(CorrNumCasesByAgeCI(inicio:fim,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(inicio:fim,1:2:end),2))];
TotalCorrectedByAgeHosp(3,:) = [sum(sum(CorrNumCasesByAge(fim+1:end,:),2)),sum(sum(CorrNumCasesByAgeCI(fim+1:end,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(fim+1:end,1:2:end),2))];
TotalCorrectedByAgeHosp(4,:) = sum(TotalCorrectedByAgeHosp(1:3,:));

TotalCorrectedByAgeDeath(1,:) = [sum(sum(CorrNumCasesByAgeD(1:inicio-1,:),2)),sum(sum(CorrNumCasesByAgeDCI(1:inicio-1,2:2:end),2)),sum(sum(CorrNumCasesByAgeDCI(1:inicio-1,1:2:end),2))];
TotalCorrectedByAgeDeath(2,:) = [sum(sum(CorrNumCasesByAgeD(inicio:fim,:),2)),sum(sum(CorrNumCasesByAgeDCI(inicio:fim,2:2:end),2)),sum(sum(CorrNumCasesByAgeDCI(inicio:fim,1:2:end),2))];
TotalCorrectedByAgeDeath(3,:) = [sum(sum(CorrNumCasesByAgeD(fim+1:end,:),2)),sum(sum(CorrNumCasesByAgeDCI(fim+1:end,2:2:end),2)),sum(sum(CorrNumCasesByAgeDCI(fim+1:end,1:2:end),2))];
TotalCorrectedByAgeDeath(4,:) = sum(TotalCorrectedByAgeDeath(1:3,:));