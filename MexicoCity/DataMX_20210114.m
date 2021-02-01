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
%%%% Mexico City, Mexico:

% DATA = importdata('Confirmados_sinave_CDMX.csv');
DATA = importdata('Confirmados_CDMX.csv');
data = DATA.data;
ndays = 0; %%% Keeping the last 10 days for forecast.
dataC = data(1:end-ndays,:);

% DATA = importdata('Hospitalizados_sinave_CDMX.csv');
DATA = importdata('Hospitalizados_CDMX.csv');
dataH = DATA.data;
ndays = 0; %%% Keeping the last 10 days for forecast.
dataH = dataH(1:end-ndays,:);

% DATA = importdata('Fallecidos_sinave_CDMX.csv');
DATA = importdata('Fallecidos_CDMX.csv');
dataD = DATA.data;
ndays = 0; %%% Keeping the last 10 days for forecast.
dataD = dataD(1:end-ndays,:);

DATA2 = importdata('Testes_CDMX.csv');
dataB = DATA2.data;
% dataB = dataB(1:size(dataC,1),:);
dataB = dataB(:,:);


%%% We shall delete the last 10 days.

t_actual = 0:size(data,1);

% %%%% Smoothing the data - averaging every 7e consecutive days:
dataC1 = dataC;
for jj=4:size(dataC,1)-3
for ii = 1:size(dataC,2) 
dataC1(jj,ii) = mean(dataC(jj-3:jj+3,ii));
end
end

dataH1 = dataH;
for jj=4:size(dataH,1)-3
for ii = 1:size(dataH,2) 
dataH1(jj,ii) = mean(dataH(jj-3:jj+3,ii));
end
end

dataD1 = dataD;
for jj=4:size(dataD,1)-3
for ii = 1:size(dataD,2) 
dataD1(jj,ii) = mean(dataD(jj-3:jj+3,ii));
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
t_span = datetime(2020,2,15) + caldays(0:length(t_actual)-1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AutoCorr = zeros; % plot auto-correlations: yes = 1, no = 0;
SaveFig = 0;  % plot auto-correlations: yes = 1, no = 0;
H = 300; % height of the plots

day = 1;

%%%%%% The time series beginning and end.

%%%% Shorter Period - closer to the mean value
inicio = 270; % 01-Aug-2020
fim = size(dataC,1)-13; % 01-Oct-2020

% %%%% Larger Period - not so close to the mean, may be nonstationary
% inicio = 136; % 14-Jul-2020
% fim = 260; % 15-Nov-2020

END = length(t_actual)-1;%inicio-1;

DataMXWithoutAge_20210114;
DataMXGender_20210114;
DataMXWithAge_20210114;

SIZE1 = 10000;
SIZE2 = 100;

disp(['Citywide & ',num2str(round(sum(CorrNumCases(1:END)))),' (',num2str(round(sum(CorrNumCasesCI(1:END,2)))),'--',num2str(round(sum(CorrNumCasesCI(1:END,1)))),') & ',...
    num2str(round(sum(CorrNumCasesD(1:END)))),' (',num2str(round(sum(CorrNumCasesDCI(1:END,2)))),'--',num2str(round(sum(CorrNumCasesDCI(1:END,1)))),') & ',...
num2str(sum(data(1:END,end))),'\\'])
disp(['Gender & ',num2str(round(sum(sum(CorrNumCasesByGender(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByGenderCI(1:END,3:4),2)))),'--',num2str(round(sum(sum(CorrNumCasesByGenderCI(1:END,1:2),2)))),') & ',...
num2str(round(sum(sum(CorrNumCasesByGenderD(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByGenderDCI(1:END,3:4),2)))),'--',num2str(round(sum(sum(CorrNumCasesByGenderDCI(1:END,1:2),2)))),') & ',...
num2str(sum(data(1:END,end))),'\\'])
disp(['Age Range & ',num2str(round(sum(sum(CorrNumCasesByAge(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByAgeCI(1:END,2:2:end),2)))),'--',num2str(round(sum(sum(CorrNumCasesByAgeCI(1:END,1:2:end),2)))),') & ',...
num2str(round(sum(sum(CorrNumCasesByAgeD(1:END,:),2)))),' (',num2str(round(sum(sum(CorrNumCasesByAgeDCI(1:END,2:2:end),2)))),'--',num2str(round(sum(sum(CorrNumCasesByAgeDCI(1:END,1:2:end),2)))),') & ',...
num2str(round(sum(data(1:END,end)))),'\\'])