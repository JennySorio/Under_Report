clear all; clc; close all; format long e; tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% We estimate the parameters of a SEIR-type epidemiological model by
%%%% using a maximum a posteriori estimator. All the estimation procedures
%%%% are carried out by LSQNONLIN, although the likelihood function (or
%%%% data misfit) is log-Poisson. The model parameters are estimated from
%%%% the daily records of infections and deaths.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setup for the ODE solver and the least-square function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Experimental Data

%%%% Daily Cases, Hospitalizations and Deaths
%%%% CHICAGO, USA:

DATA = importdata('COVID-19_Daily_Cases__Deaths__and_Hospitalizations_20201223.csv');
data = DATA.data;
ndays = 0; %%% Keeping the last 10 days for forecast.
data = data(1:end-ndays,:);

% DATA2 = importdata('Chicago_COVID-19_Daily_Testing_-_By_Person_20201003.csv');
DATA2 = importdata('COVID-19_Daily_Testing_-_By_Person_20201223.csv');
dataB = DATA2.data;
dataB = dataB(1:end-ndays,:);


%%% We shall delete the last 10 days.

t_actual = 0:size(data,1);

% %%%% Smoothing the data - averaging every 7e consecutive days:
% data1 = data;
% for jj=7:size(data,1)
% for ii = 1:size(data,2) 
% data1(jj,ii) = Mean(data(jj-6:jj,ii));
% end
% end
% 
% data2 = dataB;
% for jj=7:size(dataB,1)
% for ii = 1:size(dataB,2) 
% data2(jj,ii) = Mean(dataB(jj-6:jj,ii));
% end
% end

data1 = data;
for jj=4:size(data,1)-3
for ii = 1:size(data,2) 
data1(jj,ii) = mean(data(jj-3:jj+3,ii));
end
end

%%%% Daily Performed Tests
data2 = dataB;
for jj=4:size(dataB,1)-3
for ii = 1:size(dataB,2) 
data2(jj,ii) = mean(dataB(jj-3:jj+3,ii));
end
end
l=0;
t_span = datetime(2020,3,01) + caldays(0:length(t_actual)-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AutoCorr = zeros; % plot auto-correlations: yes = 1, no = 0;
SaveFig = 1;%zeros;  % plot auto-correlations: yes = 1, no = 0;
H = 300; % height of the plots

day = 1;

%%%%%% The time series beginning and end.

%%%% Shorter Period - closer to the Mean value
inicio = 154; % 01-Aug-2020
fim = 219; % 01-Oct-2020

% %%%% Larger Period - not so close to the Mean, may be nonstationary
% inicio = 136; % 14-Jul-2020
% fim = 260; % 15-Nov-2020

END = length(t_actual)-1;%inicio-1;

DataChicagoWithoutAge_20201229;
DataChicagoGender_20201229;
DataChicagoWithAge_20201229;

SIZE1 = 10000;
SIZE2 = 100;
for jj = 1:8
disp([agerange(jj,:),'& ',num2str(round(SIZE1*MeanHospByAge(jj))/SIZE2),' (',num2str(round(SIZE1*HospByAgeCI90(jj,1))/SIZE2),'--',num2str(round(SIZE1*HospByAgeCI90(jj,2))/SIZE2),') & ',...
num2str(round(SIZE1*MeanDeathByAge(jj))/SIZE2),' (',num2str(round(SIZE1*DeathByAgeCI90(jj,1))/SIZE2),'--',num2str(round(SIZE1*DeathByAgeCI90(jj,2))/SIZE2),') & ',...
num2str(round(SIZE1*MeanDeathInHospByAge(jj))/SIZE2),' (',num2str(round(SIZE1*DeathInHospByAgeCI90(jj,1))/SIZE2),'--',num2str(round(SIZE1*DeathInHospByAgeCI90(jj,2))/SIZE2),')\\'])
end
disp(['Female & ',num2str(round(SIZE1*MeanHospByGender(1,1))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(1,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(1,2))/SIZE2),') & ',...
    num2str(round(SIZE1*MeanHospByGender(2,1))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(3,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(3,2))/SIZE2),') & ',...
    num2str(round(SIZE1*MeanHospByGender(3,1))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(5,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(5,2))/SIZE2),')\\'])
disp(['Male & ',num2str(round(SIZE1*MeanHospByGender(1,2))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(2,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(2,2))/SIZE2),') & ',...
    num2str(round(SIZE1*MeanHospByGender(2,2))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(4,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(4,2))/SIZE2),') & ',...
    num2str(round(SIZE1*MeanHospByGender(3,2))/SIZE2),' (',num2str(round(SIZE1*HospByGenderCI90(6,1))/SIZE2),'--',num2str(round(SIZE1*HospByGenderCI90(6,2))/SIZE2),')\\'])
disp(['Citywide & ',num2str(round(SIZE1*MeanHosp)/SIZE2),' (',num2str(round(SIZE1*HospCI90(1))/SIZE2),'--',num2str(round(SIZE1*HospCI90(2))/SIZE2),') & ',...
    num2str(round(SIZE1*MeanDeath)/SIZE2),' (',num2str(round(SIZE1*DeathCI90(1))/SIZE2),'--',num2str(round(SIZE1*DeathCI90(2))/SIZE2),') & ',...
num2str(round(SIZE1*MeanDeathInHosp)/SIZE2),' (',num2str(round(SIZE1*DeathInHospCI90(1))/SIZE2),'--',num2str(round(SIZE1*DeathInHospCI90(2))/SIZE2),')\\'])


disp(['Citywide & ',num2str(round(sum(CorrNumCases(1:END)))),' (',num2str(round(sum(CorrNumCasesCI(1:END,2)))),'--',num2str(round(sum(CorrNumCasesCI(1:END,1)))),') & ',...
    num2str(round(sum(CorrNumCasesD(1:END)))),' (',num2str(round(sum(CorrNumCasesDCI(1:END,2)))),'--',num2str(round(sum(CorrNumCasesDCI(1:END,1)))),') & ',...
num2str(sum(data(1:END,end))),'\\'])
disp(['Gender & ',num2str(round(sum(sum(CorrNumCasesByGender(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByGenderCI(1:END,3:4),2)))),'--',num2str(round(sum(sum(CorrNumCasesByGenderCI(1:END,1:2),2)))),') & ',...
num2str(round(sum(sum(CorrNumCasesByGenderD(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByGenderDCI(1:END,3:4),2)))),'--',num2str(round(sum(sum(CorrNumCasesByGenderDCI(1:END,1:2),2)))),') & ',...
num2str(sum(data(1:END,end))),'\\'])
disp(['Age Range & ',num2str(round(sum(sum(CorrNumCasesByAge(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByAgeCI(1:END,2:2:end),2)))),'--',num2str(round(sum(sum(CorrNumCasesByAgeCI(1:END,1:2:end),2)))),') & ',...
num2str(round(sum(sum(CorrNumCasesByAgeD(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByAgeDCI(1:END,2:2:end),2)))),'--',num2str(round(sum(sum(CorrNumCasesByAgeDCI(1:END,1:2:end),2)))),') & ',...
num2str(round(sum(data(1:END,end)))),'\\'])