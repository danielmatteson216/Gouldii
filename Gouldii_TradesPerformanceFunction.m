function TnP = Gouldii_TradesPerformanceFunction(Commission,initialportfolio,Serial_enddate,Serial_startdate,VIX, sig, SERIAL_DATE_DATA, TargetWeightVX1, TargetWeightVX2, TradeDate, ExpDates, ContractExpirations, ContractsAsStructure_RowsAsDates,TradeDate_NumFormat,T1,T2,stoploss,TradeDay,CONTANGO, CONTANGO30, ROLL_YIELD)

%[nr,nc] = size(SERIAL_DATE_DATA);
nr = Serial_enddate - Serial_startdate+1; 
nc = 1;

%nr = nr + 1;

Temp_TargetWeightVX1 = TargetWeightVX1(Serial_startdate:Serial_enddate);
Temp_TargetWeightVX2 = TargetWeightVX2(Serial_startdate:Serial_enddate);
Temp_T1 = T1(Serial_startdate:Serial_enddate, :);
Temp_T2 = T2(Serial_startdate:Serial_enddate, :);
Temp_CONTANGO = CONTANGO(Serial_startdate:Serial_enddate, :);
Temp_CONTANGO30 = CONTANGO30(Serial_startdate:Serial_enddate, :);
Temp_ROLL_YIELD = ROLL_YIELD(Serial_startdate:Serial_enddate, :);
Temp_ContractExpirations = ContractExpirations(Serial_startdate:Serial_enddate, :);
Temp_SERIAL_DATE_DATA = SERIAL_DATE_DATA(Serial_startdate:Serial_enddate, :);
Temp_VIX = VIX(Serial_startdate:Serial_enddate, :);
Temp_TradeDate = TradeDate(Serial_startdate:Serial_enddate, :);
Temp_TradeDay = TradeDay(Serial_startdate:Serial_enddate, :);
Temp_TradeDate_NumFormat = TradeDate_NumFormat(Serial_startdate:Serial_enddate, :);
    
Exposure = sig * 100;
TargetWeightVX1postsig = Temp_TargetWeightVX1 .* sig;
TargetWeightVX2postsig = Temp_TargetWeightVX2 .* sig;

PortfolioCash = zeros(nr,nc);

PortfolioMktValPre = zeros(nr,nc);
PortfolioMktValPost = zeros(nr,nc);

PortfolioNetLiqPre = zeros(nr,nc);
PortfolioNetLiqPost = zeros(nr,nc);
       
TradeVX1Target = zeros(nr,nc);
TradeVX2Target = zeros(nr,nc);
          
TradeVX1Contracts = zeros(nr,nc);
TradeVX2Contracts = zeros(nr,nc);
           
TradeVX1Actual = zeros(nr,nc);
TradeVX2Actual = zeros(nr,nc);

PortfolioVX1ContractsPre = zeros(nr,nc);
PortfolioVX2ContractsPre = zeros(nr,nc);
           
PortfolioVX1ContractsPost = zeros(nr,nc);
PortfolioVX2ContractsPost = zeros(nr,nc);
           
PositionVX1Pre = zeros(nr,nc);
PositionVX1Post = zeros(nr,nc);

PositionVX2Pre = zeros(nr,nc);
PositionVX2Post = zeros(nr,nc);

ExposureVX1Pre = zeros(nr,nc);
ExposureVX1Post = zeros(nr,nc);

ExposureVX2Pre = zeros(nr,nc);
ExposureVX2Post = zeros(nr,nc);

VX1Price = zeros(nr,nc);
VX2Price = zeros(nr,nc);

DailyPL = zeros(nr,nc);
DailyROR = zeros(nr,nc);
CummPL =  zeros(nr,nc);
CummROR =  zeros(nr,nc);
CummSharpeRatio = zeros(nr,nc);
%MaxDD = zeros(nr,nc);
% ask user for initial portfolio size...
%        promptPortfolioInitial = {'Please Enter an Initial Portfolio Value:'};
%        Stop_title = 'Initial Portfolio Value';
%        num_lines = 1;
%        PortfolioCashInitialcell = inputdlg(promptPortfolioInitial,Stop_title,num_lines);
        
%PortfolioCashInitial = cell2mat(PortfolioCashInitialcell);
%PortfolioCashInitial = str2double(PortfolioCashInitial);
PortfolioCashInitial = initialportfolio;
PortfolioNetLiqInitial = PortfolioCashInitial;

%initialize all day zero variables except the initial portfolio value
PositionVX1ContractsInitial = 0;
PositionVX2ContractsInitial = 0;

PositionVX1PreInitial = 0;
PositionVX2PreInitial = 0;

PositionVX1PostInitial = 0;
PositionVX2PostInitial = 0;

sigInitial = 0;
stoplosscount =  0;
IsExpDate = ismember(TradeDate, ExpDates);
Temp_IsExpDate = IsExpDate(Serial_startdate:Serial_enddate, :);
TradeDay = TradeDay;
stoploss = stoploss;
VIX = VIX;
CONTANGO = CONTANGO;
CONTANGO30 = CONTANGO30;
ROLL_YIELD = ROLL_YIELD;
           
for i = 1:nr
% what happens when the trade date passes the expiration date or expected
% number of dates available in a contract
      % if VIX(i) < 11
      %     TargetWeightVX1postsig(i) = 0;
      %     TargetWeightVX2postsig(i) = 0;
      % end
     
      %need to figure out which fucking contracts are considered VX1 and
      %VX2 based on the start date!!!
     ContractUnderTest1 = char(Temp_ContractExpirations(i,1));
     ContractUnderTest2 = char(Temp_ContractExpirations(i,2));
     
     DateUnderTest = char(Temp_TradeDate(i,1));
     ColumnUnderTestOpen = 'Open';
     ColumnUnderTest = 'Close';
     ColumnUnderTestHigh = 'High';
     ColumnUnderTestLow = 'Low';
     ColumnUnderTestSettle = 'Settle';
     DataAdjustmentDate = '03/23/2007';
     TradeDateNumTest = datenum(DataAdjustmentDate, 'mm/dd/yyyy' );

     if Temp_SERIAL_DATE_DATA(i) <= TradeDateNumTest
     Asset1ClosePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTest));
     Asset2ClosePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTest));
     Asset1OpenPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestOpen));
     Asset2OpenPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestOpen));
     Asset1HighPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestHigh));
     Asset2HighPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestHigh));
     Asset1LowPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestLow));
     Asset2LowPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestLow));     
     Asset1SettlePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestSettle));
     Asset2SettlePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestSettle));     
     Asset1ClosePrice = Asset1ClosePrice/10; 
     Asset2ClosePrice = Asset2ClosePrice/10;
     Asset1OpenPrice = Asset1OpenPrice/10; 
     Asset2OpenPrice = Asset2OpenPrice/10;     
     Asset1SettlePrice = Asset1SettlePrice/10; 
     Asset2SettlePrice = Asset2SettlePrice/10;
     Asset1HighPrice = Asset1HighPrice/10;
     Asset2HighPrice = Asset2HighPrice/10;
     Asset1LowPrice = Asset1LowPrice/10;
     Asset2LowPrice = Asset2LowPrice/10;
     
     else
     Asset1ClosePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTest));
     Asset2ClosePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTest));
     Asset1OpenPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestOpen));
     Asset2OpenPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestOpen));
     Asset1HighPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestHigh));
     Asset2HighPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestHigh));
     Asset1LowPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestLow));
     Asset2LowPrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestLow));              
     Asset1SettlePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest1)(DateUnderTest,ColumnUnderTestSettle));
     Asset2SettlePrice = table2array(ContractsAsStructure_RowsAsDates.(ContractUnderTest2)(DateUnderTest,ColumnUnderTestSettle));     

     end    
 % set minimum values!! - not sure why we did this again.    
        if Asset1ClosePrice == 0
        Asset1ClosePrice = Asset1SettlePrice;
        end
        
        if Asset2ClosePrice == 0
        Asset2ClosePrice = Asset2SettlePrice;
        end
        
        if Asset1LowPrice < 7
        Asset1LowPrice = Asset1SettlePrice;
        end       

        if Asset2LowPrice < 7
        Asset2LowPrice = Asset2SettlePrice;
        end 

        if Asset1HighPrice < 7
        Asset1HighPrice = Asset1SettlePrice;
        end  
        
        if Asset2HighPrice < 7
        Asset2HighPrice = Asset2SettlePrice;
        end         
            
        if Asset1OpenPrice < 7
        Asset1OpenPrice = Asset1SettlePrice;
        end  
        
        if Asset2OpenPrice < 7
        Asset2OpenPrice = Asset2SettlePrice;
        end  
        
     VX1Price(i,1) = Asset1ClosePrice;
     VX2Price(i,1) = Asset2ClosePrice;
     VX1HighPrice(i,1) = Asset1HighPrice;
     VX2HighPrice(i,1) = Asset2HighPrice;
     VX1LowPrice(i,1) = Asset1LowPrice;
     VX2LowPrice(i,1) = Asset2LowPrice;
     VX1OpenPrice(i,1) = Asset1OpenPrice;
     VX2OpenPrice(i,1) = Asset2OpenPrice;     
     
     
  %XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  %                  The decision making shit happens here!
  %DAY ONE
        if i == 1              
           
           PositionVX1Pre(i,1) = (PositionVX1ContractsInitial * Asset1ClosePrice * 1000);
           PositionVX2Pre(i,1) = (PositionVX2ContractsInitial * Asset2ClosePrice * 1000);
                   
           
           PortfolioMktValPre(i,1) = PositionVX1PreInitial + PositionVX2PreInitial;
           
           PortfolioNetLiqPre(i,1) = PortfolioCashInitial + PortfolioMktValPre(i,1);
           
           ExposureVX1Pre(i,1) = (PositionVX1Pre(i,1) / PortfolioNetLiqPre(i,1));
           ExposureVX2Pre(i,1) = (PositionVX2Pre(i,1) / PortfolioNetLiqPre(i,1));
                                 
           TradeVX1Target(i,1) = (TargetWeightVX1postsig(i,1) - ExposureVX1Pre(i,1)) * PortfolioNetLiqPre(i,1);
           TradeVX2Target(i,1) = (TargetWeightVX2postsig(i,1) - ExposureVX2Pre(i,1)) * PortfolioNetLiqPre(i,1);   

           TradeVX1Contracts(i,1) = round(TradeVX1Target(i,1) / (Asset1ClosePrice*1000));
           TradeVX2Contracts(i,1) = round(TradeVX2Target(i,1) / (Asset2ClosePrice*1000)); 
                                 
           TradeVX1Actual(i,1) = Asset1ClosePrice * 1000 * TradeVX1Contracts(i,1);
           TradeVX2Actual(i,1) = Asset2ClosePrice * 1000 * TradeVX2Contracts(i,1);
           
           PortfolioCash(i,1) = (PortfolioCashInitial) - TradeVX1Actual(i,1) - TradeVX2Actual(i,1); 
           
           PortfolioVX1ContractsPre(i,1) = PositionVX1ContractsInitial;
           PortfolioVX2ContractsPre(i,1) = PositionVX2ContractsInitial;
                                 
           PortfolioVX1ContractsPost(i,1) = PositionVX1ContractsInitial + TradeVX1Contracts(i,1);
           PortfolioVX2ContractsPost(i,1) = PositionVX2ContractsInitial + TradeVX2Contracts(i,1);
           
           PositionVX1Post(i,1) = Asset1ClosePrice * PortfolioVX1ContractsPost(i,1) * 1000;
           PositionVX2Post(i,1) = Asset2ClosePrice * PortfolioVX2ContractsPost(i,1) * 1000;

           PortfolioMktValPost(i,1) = PositionVX1Post(i,1) + PositionVX2Post(i,1);          
           PortfolioNetLiqPost(i,1) = PortfolioMktValPost(i,1) + PortfolioCash(i,1);

           ExposureVX1Post(i,1) = (PositionVX1Post(i,1) / PortfolioNetLiqPost(i,1));
           ExposureVX2Post(i,1) = (PositionVX2Post(i,1) / PortfolioNetLiqPost(i,1));
           
           DailyPL(i,1) = 0;
           DailyROR(i,1) = 0;
           CummPL(i,1) = 0;
           CummROR(i,1) = 0;
           CummSharpeRatio(i,1) = 0;
           %MaxDD(i,1) = 0;
           frisig_vx1(i,1) = 0;
           frisig_vx2(i,1) = 0;
           
           if Temp_TradeDay(i) == 2
           TradeVX1TargetMonday(i,1) = 0;
           TradeVX2TargetMonday(i,1) = 0;
           TradeVX1ActualMonday(i,1) = 0;
           TradeVX2ActualMonday(i,1) = 0;
           TradeVX1ContractsMonday(i,1) = 0;
           TradeVX2ContractsMonday(i,1) = 0;  
           end
 % -----------------------------------------------------------------------
           % DAY 2 --> "today"
        elseif i > 1          
            
    %nig rig for contracts pre....
            if Temp_IsExpDate(i) == 1
                PortfolioVX1ContractsPre(i,1) = PortfolioVX2ContractsPost(i-1,1);
                PortfolioVX2ContractsPre(i,1) = 0;  
                PortfolioCashPre(i,1) = PortfolioCash(i-1,1);
          
            
        elseif Temp_TradeDay(i) == 2 % this happens on monday            
                TradeVX1TargetMonday(i,1) = frisig_vx1(i-1,1) * PortfolioNetLiqPost(i-1,1); 
                TradeVX2TargetMonday(i,1) = frisig_vx2(i-1,1) * PortfolioNetLiqPost(i-1,1); 
                TradeVX1ContractsMonday(i,1) = round(TradeVX1TargetMonday(i,1) / (Asset1OpenPrice*1000));
                TradeVX2ContractsMonday(i,1) = round(TradeVX2TargetMonday(i,1) / (Asset2OpenPrice*1000));
                TradeVX1ActualMonday(i,1) = Asset1OpenPrice * 1000 * TradeVX1ContractsMonday(i,1);
                TradeVX2ActualMonday(i,1) = Asset2OpenPrice * 1000 * TradeVX2ContractsMonday(i,1);
                PortfolioCashPre(i,1) = (PortfolioCash(i-1,1) - TradeVX1ActualMonday(i,1) - TradeVX2ActualMonday(i,1));              
                
                PortfolioVX1ContractsPre(i,1) = PortfolioVX1ContractsPost(i-1,1) + TradeVX1ContractsMonday(i,1);                
                PortfolioVX2ContractsPre(i,1) = PortfolioVX2ContractsPost(i-1,1) + TradeVX2ContractsMonday(i,1); 
                        
            else
                TradeVX1TargetMonday(i,1) = 0;                                     
                TradeVX2TargetMonday(i,1) = 0;
                TradeVX1ActualMonday(i,1) = 0;
                TradeVX2ActualMonday(i,1) = 0;
                TradeVX1ContractsMonday(i,1) = 0;
                TradeVX2ContractsMonday(i,1) = 0;
                
                PortfolioVX1ContractsPre(i,1) = PortfolioVX1ContractsPost(i-1,1);                
                PortfolioVX2ContractsPre(i,1) = PortfolioVX2ContractsPost(i-1,1);                       
                PortfolioCashPre(i,1) = PortfolioCash(i-1,1);
            end            
            
            %calculate the netliq bottom for the stop loss calculation
            if stoploss > 0
              
                if sig(i-1) < 0 | (frisig_vx1(i-1,1) + frisig_vx2(i-1,1) < 0)
                    NetliqBottom(i,1) = (PortfolioVX1ContractsPre(i,1) * VX1HighPrice(i,1) * 1000) + (PortfolioVX2ContractsPre(i,1) * VX2HighPrice(i,1) * 1000) + PortfolioCashPre(i,1);

                elseif sig(i-1) > 0 | (frisig_vx1(i-1,1) + frisig_vx2(i-1,1) > 0)   
                    NetliqBottom(i,1) = (PortfolioVX1ContractsPre(i,1) * VX1LowPrice(i,1) * 1000) + (PortfolioVX2ContractsPre(i,1) * VX2LowPrice(i,1) * 1000) + PortfolioCashPre(i,1);   
                else
                    NetliqBottom(i,1) = PortfolioNetLiqPost(i-1,1);
                end
            Stoplosscheck(i,1) =  PortfolioNetLiqPost(i-1,1) * (1 - stoploss) ;  
            end
%---------------------------------------------------------------------------            
              % whether or not the stop loss has been triggered will force
              % the following if statemen   
              
              %   
              % THE MOTHA FUCKIN STOP LOSS IS TRIGGERED YOU TOAD
                        if (NetliqBottom(i,1) < Stoplosscheck(i,1)) && (stoploss > 0)
                               
                           stoplossTrigger(i,1) = 1;
                           stoplosscount =  stoplosscount + 1;

                           PortfolioCash(i,1) = PortfolioNetLiqPost(i-1,1) * (1 - stoploss);

                           PortfolioVX1ContractsPost(i,1) = 0;
                           PortfolioVX2ContractsPost(i,1) = 0;      

                           PositionVX1Post(i,1) = Asset1ClosePrice * PortfolioVX1ContractsPost(i,1) * 1000;
                           PositionVX2Post(i,1) = Asset2ClosePrice * PortfolioVX2ContractsPost(i,1) * 1000;

                           sig(i,1) = 0;
                           frisig_vx1(i,1)= 0;
                           frisig_vx2(i,1)= 0;
              % can be active and not triggered -- or not active at all        
                        else

                            stoplossTrigger(i,1) = 0;

                                    if Temp_TradeDay(i) == 6          % this happens on friday
                                        frisig_vx1(i,1)= (TargetWeightVX1postsig(i,1));
                                        frisig_vx2(i,1)= (TargetWeightVX2postsig(i,1));                                
                                        sig(i,1) = 0;
                                    else
                                        frisig_vx1(i,1)= 0;
                                        frisig_vx2(i,1)= 0;    
                                    end              
                                    

                            % THIS IS THE END OF THE DAY TRADING
                            %------------------------------------------------------------------------------
                            PositionVX1Pre(i,1) = (PortfolioVX1ContractsPre(i,1) * Asset1ClosePrice * 1000);
                            PositionVX2Pre(i,1) = (PortfolioVX2ContractsPre(i,1) * Asset2ClosePrice * 1000);                     

                            PortfolioMktValPre(i,1) = PositionVX1Pre(i,1) + PositionVX2Pre(i,1);
                            PortfolioNetLiqPre(i,1) = PortfolioCashPre(i,1) + PortfolioMktValPre(i,1);                                        

                            ExposureVX1Pre(i,1) = (PositionVX1Pre(i,1) / PortfolioNetLiqPre(i,1));
                            ExposureVX2Pre(i,1) = (PositionVX2Pre(i,1) / PortfolioNetLiqPre(i,1));          

                            TradeVX1Target(i,1) = (TargetWeightVX1postsig(i,1) - ExposureVX1Pre(i,1)) * PortfolioNetLiqPre(i,1);
                            TradeVX2Target(i,1) = (TargetWeightVX2postsig(i,1) - ExposureVX2Pre(i,1)) * PortfolioNetLiqPre(i,1);
                                   
                                   
                                    if sig(i) == 0 && sig(i-1) ~= 0
                                        TradeVX1Contracts(i,1) = PortfolioVX1ContractsPre(i,1)* -1;
                                        TradeVX2Contracts(i,1) = PortfolioVX2ContractsPre(i,1)* -1;
                                    else   
                                    %made change here  % do we need to fix the round up vs round
                                    %down logic here?
                                        TradeVX1Contracts(i,1) = round(TradeVX1Target(i,1) / (Asset1ClosePrice*1000));
                                        TradeVX2Contracts(i,1) = round(TradeVX2Target(i,1) / (Asset2ClosePrice*1000));           
                                    end

                                    if TradeVX1Contracts(i,1) <= 0
                                       TradeVX1Actual(i,1) = ((Asset1ClosePrice - .035) * 1000 * TradeVX1Contracts(i,1))*(1-Commission);
                                    elseif TradeVX1Contracts(i,1) > 0
                                       TradeVX1Actual(i,1) = ((Asset1ClosePrice + .035) * 1000 * TradeVX1Contracts(i,1))*(1+Commission);
                                   end 
                                    
                                    if TradeVX2Contracts(i,1) <= 0
                                       TradeVX2Actual(i,1) = ((Asset2ClosePrice - .035) * 1000 * TradeVX2Contracts(i,1))*(1-Commission);                                        
                                    elseif TradeVX2Contracts(i,1) > 0
                                       TradeVX2Actual(i,1) = ((Asset2ClosePrice + .035) * 1000 * TradeVX2Contracts(i,1))*(1+Commission);                                        
                                    end 
                                   
                           PortfolioCash(i,1) = (PortfolioCashPre(i,1) - TradeVX1Actual(i,1) - TradeVX2Actual(i,1));    
                             
                           PortfolioVX1ContractsPost(i,1) = PortfolioVX1ContractsPre(i,1) + TradeVX1Contracts(i,1);
                           PortfolioVX2ContractsPost(i,1) = PortfolioVX2ContractsPre(i,1) + TradeVX2Contracts(i,1);      

                           PositionVX1Post(i,1) = Asset1ClosePrice * PortfolioVX1ContractsPost(i,1) * 1000;
                           PositionVX2Post(i,1) = Asset2ClosePrice * PortfolioVX2ContractsPost(i,1) * 1000;
                           
                        end       
                                  
              
           PortfolioMktValPost(i,1) = PositionVX1Post(i,1) + PositionVX2Post(i,1);
           PortfolioNetLiqPost(i,1) = PortfolioCash(i,1) + PortfolioMktValPost(i,1);
           
           ExposureVX1Post(i,1) = (PositionVX1Post(i,1) / PortfolioNetLiqPost(i,1));
           ExposureVX2Post(i,1) = (PositionVX2Post(i,1) / PortfolioNetLiqPost(i,1));
        
           %Performance
           DailyPL(i,1) = PortfolioNetLiqPost(i,1) - PortfolioNetLiqPost(i-1,1); 
           DailyROR(i,1) = DailyPL(i,1) / PortfolioNetLiqPost(i-1,1); 
           CummPL(i,1) = sum(DailyPL);
           CummROR(i,1) = CummPL(i,1) / PortfolioNetLiqPost(1,1);
           CummSharpeRatio(i,1) = (mean(DailyROR) / std(DailyROR)) * sqrt(252);
           
        end
 
end

%output file used for data analysis
PortfolioLabels = {'TradeDate','TradeDay','T1','T2','VX1OpenPrice','VX1LowPrice','VX1Price','VX1HighPrice','VX2OpenPrice','VX2LowPrice', ...
                   'VX2Price','VX2HighPrice','TargetWeightVX1', 'TargetWeightVX2', 'SIGNALS','stoplossTrigger','TargetWeightVX1postsig', 'TargetWeightVX2postsig','TradeVX1Target', 'TradeVX1Contracts', ...
                   'TradeVX1Actual', 'TradeVX2Target', 'TradeVX2Contracts', 'TradeVX2Actual', 'PortfolioCash', 'PortfolioMktValPre', 'PortfolioNetLiqPre', 'PortfolioMktValPost', 'PortfolioNetLiqPost', 'PositionVX1Pre', ...
                   'PositionVX1Post','PortfolioVX1ContractsPre', 'PortfolioVX1ContractsPost', 'PositionVX2Pre', 'PositionVX2Post','PortfolioVX2ContractsPre', 'PortfolioVX2ContractsPost', 'ExposureVX1Pre', 'ExposureVX1Post', 'ExposureVX2Pre', ...
                   'ExposureVX2Post', 'DailyPL', 'DailyROR', 'CummPL', 'CummROR','CummSharpeRatio', ...
                   'TradeVX1TargetMonday','TradeVX2TargetMonday','TradeVX1ActualMonday', ...
                   'TradeVX2ActualMonday','VIX','CONTANGO','CONTANGO30','ROLL_YIELD'};

InitialValues = [0,0,0,0,0,0,0,0,0,0, ...
                 0,0,0,0,0,0,0,0,0,0, ...
                 0,0,0,0,PortfolioCashInitial,0,0,0,PortfolioCashInitial, 0, ...
                 0,0,0,0,0,0,0,0,0,0, ...
                 0,0,0,0,0,0, ...
                 0,0,0, ...
                 0,0,0,0,0];

TotalPortfolio = [Temp_TradeDate_NumFormat,Temp_TradeDay,Temp_T1,Temp_T2,VX1OpenPrice,VX1LowPrice,VX1Price,VX1HighPrice,VX2OpenPrice,VX2LowPrice, ...
                  VX2Price,VX2HighPrice, Temp_TargetWeightVX1, Temp_TargetWeightVX2, sig, stoplossTrigger, TargetWeightVX1postsig, TargetWeightVX2postsig, TradeVX1Target, TradeVX1Contracts, ...
                  TradeVX1Actual, TradeVX2Target, TradeVX2Contracts, TradeVX2Actual, PortfolioCash, PortfolioMktValPre, PortfolioNetLiqPre, PortfolioMktValPost, PortfolioNetLiqPost, PositionVX1Pre, ...
                  PositionVX1Post, PortfolioVX1ContractsPre, PortfolioVX1ContractsPost, PositionVX2Pre, PositionVX2Post, PortfolioVX2ContractsPre, PortfolioVX2ContractsPost, ExposureVX1Pre, ExposureVX1Post, ExposureVX2Pre, ...
                  ExposureVX2Post, DailyPL, DailyROR, CummPL, CummROR,CummSharpeRatio, ...
                  TradeVX1TargetMonday,TradeVX2TargetMonday,TradeVX1ActualMonday, ...
                  TradeVX2ActualMonday,Temp_VIX,Temp_CONTANGO,Temp_CONTANGO30,Temp_ROLL_YIELD];
              
TotalPortfolio = [InitialValues; TotalPortfolio];
TotalPortfolio = num2cell(TotalPortfolio);
TotalPortfolio = cat(1,PortfolioLabels, TotalPortfolio);
%TnP = TotalPortfolio;

stoplosscount = num2str(stoplosscount);
disp('Number of stop losses activated')
disp(stoplosscount)

TnP = TotalPortfolio;


save('Volatility_TradesPerformance');

end

