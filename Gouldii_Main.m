
clc
clear
close all
% comment the below line if you dont want to run the get data code
run('Gouldii_GetData.m');
% un comment the below line if you want to run the previous runs data set
%load('Volatility_GetData.mat')

% ----------------------------------------

% comment the below line if you dont want to run the parameters code
run('Gouldii_Parameters.m');
% un comment the below line if you want to run the previous runs data set
%load('Volatility_Parameters.mat')

% ----------------------------------------

% comment the below line if you dont want to run the DateRange code
run('Gouldii_DateRange.m');
% un comment the below line if you want to run the previous runs data set
%load('Volatility_Parameters_RangeDate.mat')

% ----------------------------------------

% comment the below line if you dont want to run the FuturesSignal Linear
% Optimizer.
run('Gouldii_SignalsLinearOptimizer.m');


% ----------------------------------------

% comment the below line if you dont want to run the FuturesSignal Linear
% Optimizer.
%run('Gouldii_SignalsLinearOptimizer.m');

% ----------------------------------------
