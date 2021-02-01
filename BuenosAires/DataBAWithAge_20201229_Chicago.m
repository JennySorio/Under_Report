%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
day = 1;
stationarityC = zeros(8,4);

meanHospByAge = [0.0111735330836454 0.0204584738669401 0.0268623872906827 0.0421713118342332 0.0645161290322581 0.126111472565604 0.246565029173725 0.362373737373737];
HospByAgeCI90 = [0.00340136054421769 0.0259259259259259;0.0145502645502646 0.0252365930599369;0.0153846153846154 0.0428265524625268;0.0215311004784689 0.0618892508143323;0.0383386581469649 0.103603603603604;0.0842696629213483 0.171232876712329;0.140495867768595 0.321428571428571;0.193548387096774 0.500000000000000];
HospByAgeStd = zeros(8,2);


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

meanDeathByAge(end-2:end) = [0.0278553693358163 0.0663003663003663 0.175735294117647];
DeathByAgeCI90(end-2:end,:) = [0.105263157894737 0.333333333333333;0.181818181818182 0.454545454545455;0.190476190476190 1.28571428571429];

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(num2str(round([sum(sum(CorrNumCasesByAge(1:END,:),2)),sum(sum(CorrNumCasesByAgeCI(1:END,2:2:end),2)),sum(sum(CorrNumCasesByAgeCI(1:END,1:2:end),2))])))
disp(num2str(round([sum(sum(CorrNumCasesByAgeD(1:END,:),2)),sum(sum(CorrNumCasesByAgeDCI(1:END,2:2:end),2)),sum(sum(CorrNumCasesByAgeDCI(1:END,1:2:end),2))])))
disp(num2str(round(sum(dataC1(1:END,end)))))
