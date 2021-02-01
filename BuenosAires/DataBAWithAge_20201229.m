%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
day = 1;
stationarityC = zeros(8,4);

meanHospByAge = zeros(1,8);
HospByAgeCI90 = zeros(8,2);
HospByAgeStd = zeros(8,2);
for jj = 1:8
aux = dataH1(1+day:end,jj)./dataC1(1:end-day,jj);
aux = aux(inicio:fim);
meanHospByAge(jj) = median(aux);
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

CorrByAge = zeros(size(dataC1,1)-day,8);
CorrByAgeCI = zeros(size(dataC1,1)-day,16);
CorrNumCasesByAge = dataC1(:,1:8);
CorrNumCasesByAgeCI = zeros(size(dataC1,1),16);
CorrNumCasesByAgeCI(:,1:2:end) = dataC1(:,1:8);
CorrNumCasesByAgeCI(:,2:2:end) = dataC1(:,1:8);
for jj = 1:8
if meanHospByAge(jj)==0
CorrByAge(:,jj) = ones;
else
CorrByAge(:,jj) = ...
    max(1,min(1,dataH1(1+day:end,jj)./dataC1(1:end-day,jj))/meanHospByAge(jj));
end
CorrNumCasesByAge(1:end-day,jj) = CorrNumCasesByAge(1:end-day,jj).*CorrByAge(:,jj);

if HospByAgeCI90(jj,1) == 0
CorrByAgeCI(:,(jj-1)*2+1) = ones;
else
CorrByAgeCI(:,(jj-1)*2+1) = ...
        max(1,min(1,dataH1(1+day:end,jj)./dataC1(1:end-day,jj))/HospByAgeCI90(jj,1));
end
CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+1) = ...
          CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+1).*CorrByAgeCI(:,(jj-1)*2+1);
if HospByAgeCI90(jj,2) == 0
CorrByAgeCI(:,(jj-1)*2+2) = ones;
else
CorrByAgeCI(:,(jj-1)*2+2) = ...
        max(1,min(1,dataH1(1+day:end,jj)./dataC1(1:end-day,jj))/HospByAgeCI90(jj,2));
end
CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+2) = ...
          CorrNumCasesByAgeCI(1:end-day,(jj-1)*2+2).*CorrByAgeCI(:,(jj-1)*2+2);

end

%%%% Death
day = 12;

stationarityD = zeros(8,4);

meanDeathByAge = zeros(1,8);
DeathByAgeCI90 = zeros(8,2);
for jj = 1:8
aux = dataD1(1+day:end,jj)./dataC1(1:end-day,jj);
aux = min(100,aux(inicio:fim));
aux = aux(isnan(aux)==0);
aux = aux(isinf(aux)==0);
meanDeathByAge(jj) = median(aux);
stationarityD(jj,:) = [adftest(aux),kpsstest(aux), pptest(aux),vratiotest(aux)];
aux = sort(aux);
aux2 = round(0.05*length(aux));
aux = aux(aux2+1:end-aux2,:);
% if jj > 1
% aux = aux(aux>0);
% end
DeathByAgeCI90(jj,:) = [min(aux),max(aux)];
end

CorrByAgeD = zeros(size(dataC1,1)-day,8);
CorrByAgeDCI = zeros(size(dataC1,1)-day,16);
CorrNumCasesByAgeD = dataC1(:,1:8);
CorrNumCasesByAgeDCI = zeros(size(dataC1,1),16);
CorrNumCasesByAgeDCI(:,1:2:end) = dataC1(:,1:8);
CorrNumCasesByAgeDCI(:,2:2:end) = dataC1(:,1:8);
for jj = 1:8
if meanDeathByAge(jj) == 0
CorrByAgeD(:,jj) = ones;%CorrByAge(:,jj);
else
CorrByAgeD(:,jj) = ...
    max(1,min(1,dataD1(1+day:end,jj)./dataC1(1:end-day,jj))/meanDeathByAge(jj));
end
aux = CorrByAgeD(:,jj);
aux(aux==0)=ones;
CorrNumCasesByAgeD(1:end-day,jj) = CorrNumCasesByAgeD(1:end-day,jj).*aux;
if DeathByAgeCI90(jj,1) == 0
CorrByAgeDCI(:,(jj-1)*2+1) = CorrByAgeD(:,jj);%CorrByAgeCI(:,(jj-1)*2+1);
else
CorrByAgeDCI(:,(jj-1)*2+1) = ...
        max(1,min(1,dataD1(1+day:end,jj)./dataC1(1:end-day,jj))/DeathByAgeCI90(jj,1));
end
aux = CorrByAgeDCI(:,(jj-1)*2+1);
aux(aux==0)=ones;
CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+1) = ...
          CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+1).*aux;
if DeathByAgeCI90(jj,1) == 0
CorrByAgeDCI(:,(jj-1)*2+2) = ones;%CorrByAgeCI(:,(jj-1)*2+2);
else
CorrByAgeDCI(:,(jj-1)*2+2) = ...
        max(1,min(1,dataD1(1+day:end,jj)./dataC1(1:end-day,jj))/DeathByAgeCI90(jj,2));
end
aux = CorrByAgeDCI(:,(jj-1)*2+2);
aux(aux==0)=ones;
CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+2) = ...
          CorrNumCasesByAgeDCI(1:end-day,(jj-1)*2+2).*aux;
end


%%%% Death in Hospital
day = 11;
stationarityE = zeros(8,4);

meanDeathInHospByAge = zeros(1,8);
DeathInHospByAgeCI90 = zeros(8,2);
for jj = 1:8
aux = dataD1(1+day:end,jj)./dataH1(1:end-day,jj);
aux = min(100,aux(inicio:fim));
aux = aux(isnan(aux)==0);
aux = aux(isinf(aux)==0);
meanDeathInHospByAge(jj) = median(aux);
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

figure
hold on
% grid on
box on
title('Daily Infections - Buenos Aires')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
% plot(t_span(2:end),data1(:,1),'r','LineWidth',1)
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAge,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
area([t_span(2),t_span(inicio)],[25000,25000],'FaceAlpha',0.3,'FaceColor',[249,208,160]/255,'linestyle',':')
area([t_span(inicio),t_span(fim)],[25000,25000],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
area([t_span(fim),t_span(end)],[25000,25000],'FaceAlpha',0.3,'FaceColor',[193,253,199]/255,'linestyle',':')
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,5000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsAge_BA.fig');
print('-dpng','InfectionsAge_BA');
end

figure
hold on
% grid on
box on
title('Daily Infections - Buenos Aires')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
% plot(t_span(2:end),data1(:,1),'r','LineWidth',1)
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAgeD,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
area([t_span(2),t_span(inicio)],[30000,30000],'FaceAlpha',0.3,'FaceColor',[249,208,160]/255,'linestyle',':')
area([t_span(inicio),t_span(fim)],[30000,30000],'FaceAlpha',0.3,'FaceColor',[133,193,233]/255,'linestyle',':')
area([t_span(fim),t_span(end)],[30000,30000],'FaceAlpha',0.3,'FaceColor',[193,253,199]/255,'linestyle',':')
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,10000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsAgeD_BA.fig');
print('-dpng','InfectionsAgeD_BA');
end

disp('BA (Hosp. Rate):')
disp([agerange,num2str(100*[meanHospByAge',HospByAgeCI90])])
disp([agerange,num2str(stationarityC)])

disp('BA (Death Rate):')
disp([agerange,num2str(100*[meanDeathByAge',DeathByAgeCI90])])
disp([agerange,num2str(stationarityD)])

disp('BA (Death Rate in Hosp):')
disp([agerange,num2str(100*[meanDeathInHospByAge',DeathInHospByAgeCI90])])
disp([agerange,num2str(stationarityE)])

ResultsAge = 100*[meanHospByAge',HospByAgeCI90,meanDeathByAge',DeathByAgeCI90,meanDeathInHospByAge',DeathInHospByAgeCI90];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(num2str(round([sum(sum(CorrNumCasesByAge(1:END,:),2)),sum(sum(CorrNumCasesByAgeCI(1:END,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(1:END,1:2:end),2))])))
disp(num2str(round(sum(dataC1(1:END,1)))))

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