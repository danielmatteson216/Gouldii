clear; close all; clc

%load('Volatility_Parameters_RangeDate_contractlist.mat');
load('Volatility_Parameters_RangeDate.mat');

ObjectName = @(x) inputname(1);

%calculate length of test vector
SERIAL_DATE_LEN = length(SERIAL_DATE_DATA);
TradeDate_String = datestr(SERIAL_DATE_DATA, 'yyyymmdd');
TradeDate_cellarray = cellstr(TradeDate_String);

% Stop loss percentage
stoploss = .10;

%optimize the contango entry variable...
% how many steps?
numofsteps = 2;
upperbound = 0.10;
lowerbound = 0.08;
h = (upperbound - lowerbound) / numofsteps;

% set the optimized parameter
ContangoEntry = (lowerbound:h:upperbound);
OptParamName = ObjectName(ContangoEntry);
OptParam = ContangoEntry;

%new Futures Signals declarations:
%ContangoEntry = 0.06;
Contango30Entry = 0.1;
ContangoExit = 0.035;
Contango30Exit = 0.1;
LongContangoEntry = -0.05;
LongContango30Entry = 0;

%Opt Param cell array
OptParamLabel = {OptParamName};
OptParam = num2cell(OptParam);
OptParamCell = cat(2,OptParamLabel, OptParam);
OptParamCell = OptParamCell';

%create cell array to hold results
EXCEL_ALGO_SIGNAL = cell(SERIAL_DATE_LEN,6);
%create cell array to hold order
XIV_FUTURE_SIGNAL = cell(SERIAL_DATE_LEN,12);

%initialize flags
%flag_future = 1;
 j = 1;
 k = 1;
 
 % ask user for initial portfolio size...
 %       promptPortfolioInitial = {'Please Enter an Initial Portfolio Value:'};
 %       Stop_title = 'Initial Portfolio Value';
 %       num_lines = 1;
 %       PortfolioCashInitialcell = inputdlg(promptPortfolioInitial,Stop_title,num_lines);
 
 for j = 1:length(ContangoEntry)
 
    for i = 1:length(SERIAL_DATE_DATA)

        if i == 1 
            sig(i,1) = 0;
      
        elseif i > 1  

            if (CONTANGO(i) > ContangoEntry(j) && CONTANGO30(i) > Contango30Entry && sig(i-1,1) == 0) %previous step 
                sig(i,1) = -1;
               
           
            elseif (CONTANGO(i) > ContangoExit && CONTANGO30(i) > Contango30Exit && sig(i-1,1) < 0) % 
                sig(i,1) = -1;

            elseif (CONTANGO(i) < LongContangoEntry && CONTANGO30(i) < LongContango30Entry) 
                sig(i,1) = 0.1;
                
            else 
                sig(i,1) = 0;                
        
            end

        end

 
    end
    
    sigvec(:,j) = sig;
    %Call the trades and performance function...
    VixLinearOpt = Gouldii_TradesPerformanceFunction(VIX, sig, SERIAL_DATE_DATA, TargetWeightVX1, TargetWeightVX2, TradeDate, ExpDates, ContractExpirations, ContractsAsStructure_RowsAsDates,TradeDate_NumFormat,T1,T2,stoploss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD);
    OUTPUT_CELL_ARRAY{j} = VixLinearOpt;
    NetLiqTotal(:,j) = OUTPUT_CELL_ARRAY{1,j}(2:end,29);
    SharpeRatio(1,j) = OUTPUT_CELL_ARRAY{1,j}(end,46);
    CummRORcell(1,j) = OUTPUT_CELL_ARRAY{1,j}(end,45);
    CummROR = cell2mat(CummRORcell);
    NetProfit(1,j) = cell2mat(NetLiqTotal(end,j)) - cell2mat(NetLiqTotal(1,j));
    
 
    
     NetLiqTotalMatrix = cell2mat(NetLiqTotal);
     NetLiqTotalTest = NetLiqTotalMatrix(NetLiqTotalMatrix < 0);
     NetLiqTotalempty = isempty(NetLiqTotalTest);
     
    if NetLiqTotalempty == 1
        [MaxDD(j,1),MaxDDindextemp] = maxdrawdown(cell2mat(NetLiqTotal(:,j)));
        MaxDDindex(j,:) = MaxDDindextemp;
    
    elseif NetLiqTotalempty == 0
        MaxDD(j,1) = 0;
        MaxDDindex(j,1) = 0;
    end       
    
       
       LinearOptResults(j,1) = OptParamCell(1,1);
       LinearOptResults(j,2) = OptParamCell(j+1,1);
       
       if j == 1
       LinearOptResults(j,3) = num2cell(Contango30Entry);
       LinearOptResults(j,4) = num2cell(ContangoExit);
       LinearOptResults(j,5) = num2cell(Contango30Exit);
       LinearOptResults(j,6) = num2cell(LongContangoEntry);
       LinearOptResults(j,7) = num2cell(LongContango30Entry);           
       elseif j > 1
       LinearOptResults(j,3) = LinearOptResults(j-1,3);
       LinearOptResults(j,4) = LinearOptResults(j-1,4);
       LinearOptResults(j,5) = LinearOptResults(j-1,5);
       LinearOptResults(j,6) = LinearOptResults(j-1,6);
       LinearOptResults(j,7) = LinearOptResults(j-1,7);           
       end    

       LinearOptResults(j,8) = num2cell(MaxDD(j,1));
       LinearOptResults(j,9) = num2cell(NetProfit(1,j));
       LinearOptResults(j,10) = SharpeRatio(1,j);
       LinearOptResults(j,11) = num2cell(CummROR(1,j)^(365/length(SERIAL_DATE_DATA)));
%       LinearOptResults(j,10) = num2cell(MaxDDindex(1,j));
       
 end

 
if NetLiqTotalempty == 0
disp('Net Liq is negative');
elseif NetLiqTotalempty == 1
disp('Net Liq is positive');
end
    
MaxDrawdowntotal = horzcat(MaxDD,MaxDDindex);
  
LinearOptLabels = {'Optimized Param', 'Opt_Stepsize', 'Contango30Entry', 'ContangoExit', 'Contango30Exit', 'LongContangoEntry', 'LongContango30Entry', 'MaxDD', 'NetProfit', 'SharpeRatio', 'Annualized_Return'};   
LinearOptResults = cat(1, LinearOptLabels, LinearOptResults);   
   
clear('emptycell68','XIVindexstop','TradeDate_cellarray','TradeDate_String','XIV_d','XIV_difference','XIV_IN','XIV_OUT','XIV_IN_price','XIV_OUT_price','XIVprice_ALL','ans','emptycell79','EXCEL_ALGO_SIGNAL','DVT_sigNUM','k','lastrowend','lengthofsignals','output_file_ToadCentral','p','y','AVCI','SERIAL_DATE_LEN','VCO_direction','VTRO','VTRO_direction','VTRO_int','VXST_ROLL','VXV_ROLL','flag_combo','flag_excel','flag_final','flag_vco','flag_vec_vco','flag_vec_vtro','flag_vtro','i','j')

xlswrite('COMPLETE_OUTPUT_ARRAY.xlsx',COMPLETE_OUTPUT_ARRAY);
xlswrite('TOTAL_OUTPUT_ARRAY.xlsx',TOTAL_OUTPUT_ARRAY);
xlswrite('LinearOptResults.xlsx',LinearOptResults);
xlswrite('VixLinearOptResults.xlsx',VixLinearOpt);
xlswrite('MaxDrawdowntotal.xlsx',MaxDrawdowntotal);

%remove the initial value row from the net liq output array
NetLiqTotalMatrix = NetLiqTotalMatrix(2:end,:);

save('Volatility_Signals_linearopt');

LinearOptResults
[MaxSharpe,MaxSharpeIndex] = max(cell2mat(LinearOptResults(2:end,10))) 
[MaxAnnualizedReturn,MaxAnnualizedReturnIndex] = max(cell2mat(LinearOptResults(2:end,11)))

