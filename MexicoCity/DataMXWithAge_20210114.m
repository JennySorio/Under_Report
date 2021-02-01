%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
day = 1;
meanHospByAge = [0.0111735330836454 0.0204584738669401 0.0268623872906827 0.0421713118342332 0.0645161290322581 0.126111472565604 0.246565029173725 0.362373737373737];
HospByAgeCI90 = [0.00340136054421769 0.0259259259259259;0.0145502645502646 0.0252365930599369;0.0153846153846154 0.0428265524625268;0.0215311004784689 0.0618892508143323;0.0383386581469649 0.103603603603604;0.0842696629213483 0.171232876712329;0.140495867768595 0.321428571428571;0.193548387096774 0.500000000000000];

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
meanDeathByAge = [0 0 0.00216450216450216 0.00310633905401364 0.0110969806366918 0.0278553693358163 0.0663003663003663 0.175735294117647];
DeathByAgeCI90 = [0 0;0 0.00155763239875389;0 0.00454545454545455;0 0.0123076923076923;0.00369003690036900 0.0170212765957447;0.0125786163522013 0.0440251572327044;0.0413223140495868 0.120000000000000;0.0833333333333333 0.346153846153846];

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% day = 1;
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
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAge,2),'b','LineWidth',2)
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
saveas(gcf,'InfectionsAge_MX.fig');
print('-dpng','InfectionsAge_MX');
end

figure
hold on
% grid on
box on
title('Daily Infections - Mexico City')
h1=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,1:2:end),2),'linestyle','-','FaceColor',[133,193,233]/255);
h2=area(t_span(2:end),sum(CorrNumCasesByAgeDCI(:,2:2:end),2),'linestyle','-','FaceColor',[1,1,1]);
% plot(t_span(2:end),data1(:,1),'r','LineWidth',1)
bar(t_span(2:end),dataC1(:,end),'FaceColor',[20,143,119]/255,'EdgeColor','none')
plot(t_span(2:end),sum(CorrNumCasesByAgeD,2),'b','LineWidth',2)
h1.Annotation.LegendInformation.IconDisplayStyle = 'off';
h2.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Reported','Corrected')
ylabel('Number of Individuals')
xlim([t_span(1),t_span(end-day)])
% ylim([0,10000])
xtickformat('dd-MMM')
set(gca,'FontSize',16,'FontName','Arial')
set(gcf,'Position',[100 100 600 H])
hold off
if SaveFig == 1
saveas(gcf,'InfectionsAgeD_MX.fig');
print('-dpng','InfectionsAgeD_MX');
end

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