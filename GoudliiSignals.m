%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%   Written By: Daniel James Matteson
%   Name - Date:
%   VIX_algo_version_3_Signals - 5/22/2017

%   Description:
%   This code is used to calculate all the buy/sell signals required for
%   startegy analysis using WFA Toolbox

%   Required Input Parameters:
%                   VIX
%                   T1
%                   T2
%                   T3
%                   T4
%                   T5
%                   T6
%                   T7
%                   T8
%                   T9
%                   Contango
%                   Contango 2
%                   Roll Yield
%                   VXST Roll
%                   VXV Roll
%                   VDelta
%                   VRatio
%                   (Serial Date Data)
%                   (Initial VCO condition)
%                   (Initial VTRO condition


%   Output Parameters: 
%                   EXCEL buy/sell signals
%                   VCO buy/sell signals
%                   VTRO buy/sell signals
%                   COMBO buy/sell signals



%   OUTLINE:
%       1)  Load Input Parameters
%               1.1) "Signals" Input Parameters
%       2)  Declarations and Initializations
%               2.1) Initialize Semaphores And Variables
%       3)  Strategy #1 EXCEL CODE 
%               3.1) Excel Code Logic
%       4)  Strategy #2 VCO CODE
%               4.1) VCO Definition
%               4.2) VCO Direction
%               4.3) VCO Logic
%               4.4) VCO Combo Flag
%       5)  Strategy #3 VTRO CODE
%               5.1) VTRO_int Definition
%               5.2) VTRO Definition
%               5.3) VTRO Direction
%               5.4) VTRO Logic
%               5.5) VTRO Combo Flag
%       6)  Strategy #4 COMBO CODE
%               6.1) Combo Definition
%               6.2) Combo Logic
%       7)  Signals Results
%               7.1) Excel Results
%               7.2) XIV Results
%       8)  Clear Excess Workspace Objects
%               8.1) Remove Extra Workspace Variables
%       9)  Save Workspace To File
%               9.1) Save Remaining Workspace Objects To File

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX










%=========================================================================
%-------------------------------------------------------------------------
%                 #1) LOAD INPUT PARAMETERS
%                       1.1) "Signals" Input Parameters
%-------------------------------------------------------------------------
%   1.1) "Signals" Input Parameters
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section loads the most recent saved version of the 
% input parameters necessary for this code (this is the output from the
% "Parameters" code).
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%Load the Volatility parameters file
%load('Volatility_Parameters.mat');
load('Volatility_Parameters_RangeDate.mat');
%-------------------------------------------------------------------------
%=========================================================================










%=========================================================================
%-------------------------------------------------------------------------
%                 #2) DECLARATIONS AND INITIALIZATIONS
%                       2.1) Initialize Semaphores And Variables
%-------------------------------------------------------------------------
%   2.1) Initialize Semaphores And Variables
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section initializes all semaphores and variables to be
% used througout the code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%calculate length of test vector
SERIAL_DATE_LEN = length(SERIAL_DATE_DATA);
DVT_sig = cell(SERIAL_DATE_LEN,10);
DVT_sigNUM = num2cell(SERIAL_DATE_DATA);
TradeDate_String = datestr(SERIAL_DATE_DATA, 'yyyymmdd');
TradeDate_cellarray = cellstr(TradeDate_String);
DVT_sig(:,1) = cellstr(TradeDate_cellarray);
XIVprice_ALL = num2cell(XIV);
DVT_sig(:,7) = XIVprice_ALL;

%create cell array to hold results
EXCEL_ALGO_SIGNAL = cell(SERIAL_DATE_LEN,6);
%create cell array to hold order
XIV_SIGNAL = cell(SERIAL_DATE_LEN,12);
%sig = cell(1500,2);

%initialize flags
flag_vco = 1;
 j = 1;
 k = 1;
 
%initialize VCO for backward looking data
%VCO(1) = 0;

%-------------------------------------------------------------------------
%=========================================================================










%=========================================================================
%-------------------------------------------------------------------------
%                 #4) STRATEGY #2 VCO CODE
%                       4.1) VCO Definition
%                       4.2) VCO Direction
%                       4.3) VCO Logic
%                       4.4) VCO Combo Flag
%-------------------------------------------------------------------------
%   4.1) VCO Definition
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section defines the VCO variable.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    for i = 1:numel(SERIAL_DATE_DATA)

%    if T1(i) <= 8
%            VCO(i) = (VIX(i) - 45) + (1000*CONTANGO2(i));
        
%        elseif T1(i) > 8
%            VCO(i) = (VIX(i) - 45) + (1000*CONTANGO(i));    
            
%        end
       
        
%   4.2) VCO Direction
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section defines the direction that the VCO variable is
% travelling.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       
%        if VCO(i) == VCO(1);
%            VCO_direction = 1; 
    
%        elseif VCO(i) >= VCO(i-1)
%            VCO_direction = 1; 
     
%        elseif VCO(i) < VCO(i-1)    
%            VCO_direction = -1;
    
%        end

%   4.3) VCO Logic
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section defines the logic associated with the VCO
% code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
        if i == 1 
            %sig(i,1) = 0;
      
        elseif i > 1  

            if (VCO(i) > 0 && VCO(i-1) < 0 && flag_vco == 1) %VCO_direction > 0 &&
             %   sig(i,1) = 1; %BUY
                XIV_SIGNAL{i,1} = {'1'};  
                DVT_sig(j,4) = DVT_sig(i,1);
                DVT_sig(j,2) = {'XIV_TableData'};
                DVT_sig(j,3) = {'1'};
                DVT_sig(j,9) = DVT_sig(i,7);
                flag_vco = 0;
                sig(i,1) = 1;
                j = j + 1;
      
            elseif (VCO(i) > 25 && VCO(i-1) < 25 && flag_vco == 1) %VCO_direction > 0 && 
              %  sig(i,1) = 1; %BUY
                XIV_SIGNAL{i,1} = {'1'};  
                DVT_sig(j,4) = DVT_sig(i,1);
                DVT_sig(j,2) = {'XIV_TableData'};
                DVT_sig(j,3) = {'1'}; 
                DVT_sig(j,9) = DVT_sig(i,7);                
                flag_vco = 0;
                sig(i,1) = 1;
                j = j + 1; 
      
            elseif (VCO(i) < 0 && VCO(i-1) > 0 && flag_vco == 0) % VCO_direction < 0 &&
               % sig(i,1) = 0; %SELL
                XIV_SIGNAL{i,1} = {'0'};  
                flag_vco = 1;
                DVT_sig(k,5) = DVT_sig(i,1);
                DVT_sig(k,10) = DVT_sig(i,7);
                sig(i,1) = 0;
                k = k + 1;
      
            elseif (VCO(i) < 25 && VCO(i-1) > 25 && flag_vco == 0)% VCO_direction < 0 &&
               % sig(i,1) = 0; %SELL
                XIV_SIGNAL{i,1} = {'0'};  
                flag_vco = 1;
                DVT_sig(k,10) = DVT_sig(i,7);
                DVT_sig(k,5) = DVT_sig(i,1);
                sig(i,1) = 0;
                k = k + 1;
                
            elseif flag_vco ==1
                sig(i,1) = 0;
               %sig(i,1) = 0; 
      
            elseif flag_vco ==0
                sig(i,1) = 1;
                %sig(i,1) = 0;       
        
            end
            
            %DVT_sig{94,10} = 73.67;

XIV_IN_price = DVT_sig(:,9);
XIV_OUT_price = DVT_sig(:,10);
%XIV_diff = cellfun(@(x,y) y-x,XIV_OUT_price,XIV_IN_price,'UniformOutput', false); 
%DVT_sig(:,8) = XIV_diff;
%DVT_sig(:,8) = [];
%DVT_sig(:,9) = [];
        end
 
    end
     
%-------------------------------------------------------------------------
%=========================================================================

          emptycell68 = cellfun('isempty', DVT_sig(:,4)); 
          emptycell79 = cellfun('isempty', DVT_sig(:,5));
        
      for p =1:length(emptycell79)
          if emptycell79(p) == 1 && emptycell68(p) == 0
          lastrowend = p - 1;          
          break;
          elseif emptycell79(p) == 1 && emptycell68(p) == 1
          lastrowend = p;
          break;
          end
      end
         
    
   
 
%=========================================================================
%-------------------------------------------------------------------------
%                 #7) SIGNALS RESULTS
%                       7.1) Excel Results
%                       7.2) XIV Results
%-------------------------------------------------------------------------

    for j = 1:numel(SERIAL_DATE_DATA) 
        
%   7.2) XIV Results 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section describes the results for the XIV signals
% code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%fill up the XIV_SIGNAL MATRIX        
        XIV_SIGNAL{j,2} = SERIAL_DATE_DATA(j);   
        XIV_SIGNAL{j,3} = XIV(j);
        XIV_SIGNAL{j,4} = VCO(j);  
       % XIV_SIGNAL{j,5} = VX1(j);   
       % XIV_SIGNAL{j,7} = VX2(j);
       % XIV_SIGNAL{j,9} = VX3(j);
        XIV_SIGNAL{j,6} = T1(j);   
        XIV_SIGNAL{j,8} = T2(j);
        XIV_SIGNAL{j,10} = T3(j);
%        XIV_SIGNAL{j,11} = VTRO(j);  

%convert date strings for analysis
      XIV_SIGNAL{j,2} = datestr(XIV_SIGNAL{j,2});
    
    end

% create cell array that contains the VCO signals in the format needed to
% input into the wfa toolbox performance evaluation spreadsheet. This will
% be used as the baseline to check against the optimized signals from the
% toolbox.
    DVT_sig = DVT_sig(1:lastrowend - 1,:);     
    XIV_OUT = cell2mat(DVT_sig(:,10)); 
    XIV_IN = cell2mat(DVT_sig(:,9));    
    XIV_difference = ((XIV_OUT./XIV_IN) - 1);
    XIV_d = num2cell(XIV_difference);

       %DVT_sig = DVT_sig(1:lastrowend-1,:);
       DVT_sig(:,6) = XIV_d;        

DVT_sig(:,7:end) = [];
DVT_sig(:,1) = {'ToadCentral'};
%DVT_sig = DVT_sig(1:end-1,:);

%-------------------------------------------------------------------------
%=========================================================================    
 

  lengthofsignals = length(XIV_d);
  lengthofsignals = lengthofsignals - 1;
% create a csv file for input into the WFAtoolbox excel document
  output_file_ToadCentral = fopen('ToadCentral.csv','w+');
  for y = 1:lengthofsignals
  fprintf(output_file_ToadCentral,'%s,%s,%s,%s,%s,', DVT_sig{y,1:5});
  fprintf(output_file_ToadCentral,'%f\n', DVT_sig{y,6});
  end
  fclose(output_file_ToadCentral);
  
  TradeDateSig = TradeDate_cellarray;
  TDSig = num2cell(VCO);
  TradeDateSig(:,2) = TDSig;
  output_file_TradeDateSignals = fopen('TradeDate_VCO.csv','w+');
  for y = 1:SERIAL_DATE_LEN
  fprintf(output_file_TradeDateSignals,'%s,%f\n', TradeDateSig{y,:});
  end
  fclose(output_file_TradeDateSignals);

  H_Sig = num2cell(sig);
  output_file_Signals = fopen('Hammerhead_Signals.csv','w+');
  for y = 1:SERIAL_DATE_LEN
  fprintf(output_file_Signals,'%d\n', H_Sig{y,1});
  end
  fclose(output_file_Signals);







    
%=========================================================================
%-------------------------------------------------------------------------
%                 #8) CLEAR EXCESS WORKSPACE OBJECTS
%                       8.1) Remove Extra Workspace Variables
%-------------------------------------------------------------------------
%   8.1) Remove Extra Workspace Variables 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: This section removes all workspace objects not necessary for
% operation of subsequent "Signals" code.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
clear('emptycell68','XIVindexstop','TradeDate_cellarray','TradeDate_String','XIV_d','XIV_difference','XIV_IN','XIV_OUT','XIV_IN_price','XIV_OUT_price','XIVprice_ALL','ans','emptycell79','EXCEL_ALGO_SIGNAL','DVT_sigNUM','k','lastrowend','lengthofsignals','output_file_ToadCentral','p','y','ALL_EXP_MONTH','AVCI','CONTANGO','CONTANGO2','CONTANGO_ROLL','ROLL_YIELD','SERIAL_DATE_DATA','SERIAL_DATE_LEN','T1','T2','T3','T4','T5','T6','T7','T8','T9','TradeDate','VCO_direction','VIX','VTRO','VTRO_direction','VTRO_int','VXST_ROLL','VXV_ROLL','V_DELTA','V_RATIO','flag_combo','flag_excel','flag_final','flag_vco','flag_vec_vco','flag_vec_vtro','flag_vtro','i','j')

%-------------------------------------------------------------------------
%========================================================================= 






%=========================================================================
%-------------------------------------------------------------------------
%                 #9) SAVE WORKSPACE TO FILE
%                       9.1) Save Remaining Workspace Objects To File
%-------------------------------------------------------------------------
%   9.1) Save Remaining Workspace Objects To File 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Description: The purpose of this section is to save all workspace objects
% to a file.
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%save the workspace variables to a file
save('Volatility_Signals');

%------------------------------------------------------------------------- 
%=========================================================================

