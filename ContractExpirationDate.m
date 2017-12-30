function SingleExpiry = ContractExpirationDate(CONTRACT_NAMES_ONLINE_DOWNLOADED)
IntExp = cell(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
SingleExpiryArray = cell(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
Strings = cell(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
Month = cell(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
Yearint = cell(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
onesarray = ones(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);
month_input = zeros(length(CONTRACT_NAMES_ONLINE_DOWNLOADED),1);


    for i = 1 : length(CONTRACT_NAMES_ONLINE_DOWNLOADED)
        
        SingleExpiryArray(i) = CONTRACT_NAMES_ONLINE_DOWNLOADED(i);
        
        IntExp(i) = strrep(SingleExpiryArray(i),'_VX.csv', '');
        IntExp(i) = strrep(IntExp(i),'CFE_', '');
        
        Strings(i) = regexp(IntExp(i),'.','match');
        Month(i) = Strings{i}(1);
        Yearint(i) = strcat(Strings{i}(2), Strings{i}(3));
        
        if strcmp(Month(i),'F')
            month_input(i) = 1;
            
        elseif strcmp(Month(i),'G')
            month_input(i) = 2;
            
        elseif strcmp(Month(i),'H')
            month_input(i) = 3;
            
        elseif strcmp(Month(i),'J')
            month_input(i) = 4;
            
        elseif strcmp(Month(i),'K')
            month_input(i) = 5;
            
        elseif strcmp(Month(i),'M')
            month_input(i) = 6;
            
        elseif strcmp(Month(i),'N')
            month_input(i) = 7;
            
        elseif strcmp(Month(i),'Q')
            month_input(i) = 8;
            
        elseif strcmp(Month(i),'U') 
            month_input(i) = 9;
            
        elseif strcmp(Month(i),'V')
            month_input(i) = 10;
            
        elseif strcmp(Month(i),'X')
            month_input(i) = 11;
            
        elseif strcmp(Month(i),'Z')
            month_input(i) = 12;
            
        end
        

        month_input = month_input(:);        
        y_input(i) = strcat('20',Yearint(i));
        y_input = y_input(:);
        year_input = str2double(y_input);
          
    end 
    %disp(class(year_input));
 %disp(year_input);
    
    for i = 1 : length(month_input)
        if month_input(i) == 12   
            calc_year_single(i) = year_input(i) + 1;
            calc_m_single(i) = 1;
        else
            calc_year_single(i) = year_input(i);
            calc_m_single(i) = month_input(i) + 1;
        end  
    end
    calc_m_single = calc_m_single(:);
    
    calc_year_single = calc_year_single(:);
    
 calc_date_single = [calc_year_single, calc_m_single, onesarray];     

% ------------------------------------------------------------------------


DateNumber = datenum(calc_date_single);
calc_day_1_single = weekday(DateNumber);

for i = 1 : length(month_input)

    if calc_day_1_single(i) < 7
        
            calc_day_single(i) = 6 - calc_day_1_single(i);
    else
            calc_day_single(i) = 6;
    end

    
    if calc_year_single(i) == 2014 || calc_year_single(i) == 2019 || calc_year_single(i) == 2022 || calc_year_single(i) == 2025 || calc_year_single(i) == 2030 || calc_year_single(i) == 2033 || calc_year_single(i) == 2041 || calc_year_single(i) == 2044 || calc_year_single(i) == 2049 || calc_year_single(i) == 2052 || calc_year_single(i) == 2055 || calc_year_single(i) == 2057 || calc_year_single(i) == 2060 || calc_year_single(i) == 2068 || calc_year_single(i) == 2071 || calc_year_single(i) == 2076
    
            future_year_single(i) = 1;
    else
            future_year_single(i) = 0;
    end
    
    
    if month_input(i) == 3 && future_year_single(i) == 1
            
            calculated_date_single(i) = calc_day_single(i) + 14;
    else
            calculated_date_single(i) = calc_day_single(i) + 15;
    end

        SingleExpirydate(i) = datetime(calc_year_single(i), calc_m_single(i), calculated_date_single(i)) - caldays(30);
    
end
    
SingleExpirydate = SingleExpirydate(:);
SingleExpirydate = datestr(SingleExpirydate,'mm/dd/yyyy');
SingleExpiry = SingleExpirydate;


end