function [sig,Exists_ContangoEntry,Exists_Contango30Entry,Exists_ContangoExit,Exists_Contango30Exit,Exists_LongContangoEntry,Exists_LongContango30Entry] = Gouldii_Strategy_Prime(Serial_startdate,Serial_enddate,SERIAL_DATE_DATA,CONTANGO,CONTANGO30,ContangoEntry,Contango30Entry,ContangoExit,Contango30Exit,LongContangoEntry,LongContango30Entry)
     

    % start of strategy
   % for i = 1:length(SERIAL_DATE_DATA)
   counter = 1;
     for i = Serial_startdate:Serial_enddate
        if i == Serial_startdate 
            sig(counter,1) = 0;
      
        elseif i > Serial_startdate  
            
%            [sig] = 
            
            if (CONTANGO(i) > ContangoEntry && CONTANGO30(i) > Contango30Entry && sig(counter-1,1) == 0) 
                sig(counter,1) = -1;
                
            elseif (CONTANGO(i) > ContangoExit && CONTANGO30(i) > Contango30Exit && sig(counter-1,1) < 0) % 
                sig(counter,1) = -1;
                %counter = counter+1;
            elseif (CONTANGO(i) < LongContangoEntry && CONTANGO30(i) < LongContango30Entry) 
                sig(counter,1) = 0;
                %counter = counter+1;
            else 
                sig(counter,1) = 0;                
                %counter = counter+1;
            end 

        end

 counter = counter+1;
    end % end of strategy
    
    
Exists_ContangoEntry = exist('ContangoEntry');
Exists_Contango30Entry = exist('Contango30Entry');
Exists_ContangoExit = exist('ContangoExit');
Exists_Contango30Exit = exist('Contango30Exit');
Exists_LongContangoEntry = exist('LongContangoEntry');
Exists_LongContango30Entry = exist('LongContango30Entry');


end