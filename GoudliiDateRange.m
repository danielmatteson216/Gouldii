load('Volatility_Parameters.mat');

        TradeNum = datenum(TradeDate);
        DateString = datestr(TradeDate,'MM/dd/yyyy');        
        TradeNum2 = datenum(DateString);
        TradeCell = cellstr(DateString);

%while loop
% 2 nested for loops from 1 to length of tradeDate
%   these will check each input to make sure it is a tradedate...
% we need to size all parameters separately from the table!
s1a = 1;
s1b = 1;
Emptycell = cell(1,1);
while s1a == 1

        try
        promptdateStart = {'Please Enter the Start Date in format MM/DD/YYYY: XIV trading begins 1/17/2012'};
        Start_title = 'DateRange Start Date';
        num_lines = 1;
        StartDateInput = inputdlg(promptdateStart,Start_title,num_lines);
        
        if isequal(StartDateInput,Emptycell)
            StartDateInput = '01/17/2012';
        end
        
        StartDateString = cellstr(StartDateInput);
        StartString = StartDateString{1};
        StartDateDateTime = datetime(StartDateInput,'InputFormat','MM/dd/yyyy');
        StartDateTime = datetime(StartDateDateTime,'Format','MM/dd/yyyy');
        StartDateNum = datenum(StartDateTime);
        validStr_start = validatestring(StartString,TradeCell); 
   
    for i =1:length(TradeDate)
        if  TradeNum2(i,1) == StartDateNum
            RangeStartRow = i;
            s1a = 0;
        end       
    end
       
               
        catch
        warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday');
                
        end
               
end
 
         



while s1b == 1

        try
        promptdateEnd = {'Please Enter the Stop Date in format MM/DD/YYYY:'};
        Stop_title = 'DateRange Stop Date';
        num_lines = 1;
        StopDateInput = inputdlg(promptdateEnd,Stop_title,num_lines);
        
        if isequal(StopDateInput,Emptycell)
            StopDateInput = datestr(TradeDate(end,1), 'MM/dd/yyyy');
            %StopDateInput = '05/31/2017';
        end
        
        StopDateString = cellstr(StopDateInput);
        StopString = StopDateString{1};
        StopDateDateTime = datetime(StopDateInput,'InputFormat','MM/dd/yyyy');
        StopDateTime = datetime(StopDateDateTime,'Format','MM/dd/yyyy'); 
        StopDateNum = datenum(StopDateTime);
        validStr_stop = validatestring(StopString,TradeCell); 

        if StopDateNum < StartDateNum
            msg = 'Stop Date is not after the Start Date';
            uiwait(msgbox('Stop Date is not after the Start Date'));
            error(msg);
        end    
        
        
    for i =1:length(TradeDate)
        if  TradeNum2(i,1) == StopDateNum
            RangeStopRow = i;
    
            s1b = 0;
        end       
    end
    
               
        catch
        warning('you must enter a valid trading date in the correct format. Check to ensure that the date entered is not a weekend or holiday')
                
        end
               
end


    
clear('XIVindexstart','Emptycell','s1a','s1b','DateString','i','num_lines','promptdateEnd','promptdateStart','Start_title','StartDateDateTime','StartDateInput','StartDateNum','StartDateString','StartDateTime','StartString','Stop_title','StopDateDateTime','StopDateInput','StopDateNum','StopDateString','StopDateTime','StopString','TradeCell','TradeNum','TradeNum2','validStr_start','validStr_stop');

%set index for sizing the XIV table (THE ASSET PRICE DATA!!)
XIVindexstart = 2024;
XIVindexstop = RangeStopRow - XIVindexstart;

%size each variable.
    ALL_EXP_MONTH = ALL_EXP_MONTH(RangeStartRow:RangeStopRow, :); 
    AVCI = AVCI(RangeStartRow:RangeStopRow, :); 
    CONTANGO = CONTANGO(RangeStartRow:RangeStopRow, :);                
    CONTANGO2 = CONTANGO2(RangeStartRow:RangeStopRow, :); 
    CONTANGO_ROLL = CONTANGO_ROLL(RangeStartRow:RangeStopRow, :);      
    ROLL_YIELD = ROLL_YIELD(RangeStartRow:RangeStopRow, :); 
    SERIAL_DATE_DATA = SERIAL_DATE_DATA(RangeStartRow:RangeStopRow, :); 
    T1 = T1(RangeStartRow:RangeStopRow, :); 
    T2 = T2(RangeStartRow:RangeStopRow, :);                              
    T3 = T3(RangeStartRow:RangeStopRow, :);                           
    T4 = T4(RangeStartRow:RangeStopRow, :);                          
    T5 = T5(RangeStartRow:RangeStopRow, :);                             
    T6 = T6(RangeStartRow:RangeStopRow, :);                               
    T7 = T7(RangeStartRow:RangeStopRow, :);                                
    T8 = T8(RangeStartRow:RangeStopRow, :);                             
    T9 = T9(RangeStartRow:RangeStopRow, :);                             
    TradeDate = TradeDate(RangeStartRow:RangeStopRow, :);                 
    VIX = VIX(RangeStartRow:RangeStopRow, :);                           
    VXST_ROLL = VXST_ROLL(RangeStartRow:RangeStopRow, :);                          
    VXV_ROLL = VXV_ROLL(RangeStartRow:RangeStopRow, :);       
    V_DELTA = V_DELTA(RangeStartRow:RangeStopRow, :);        
    V_RATIO = V_RATIO(RangeStartRow:RangeStopRow, :); 
    %V_PARAMETERS = V_PARAMETERS(RangeStartRow:RangeStopRow, :); 
    XIV = XIV(RangeStartRow:RangeStopRow, :); 
    VCO = VCO(RangeStartRow:RangeStopRow, :); 
    CONTANGO30 = CONTANGO30(RangeStartRow:RangeStopRow, :); 
    S30VX = S30VX(RangeStartRow:RangeStopRow, :);    
    %size asset price data
    XIV_TableData = XIV_TableData(RangeStartRow-XIVindexstart:XIVindexstop,:);




clear('XIVindexstop','XIVindexstart','RangeStartRow','RangeStopRow','Total_Vix_Rows'); 
save('Volatility_Parameters_RangeDate');    