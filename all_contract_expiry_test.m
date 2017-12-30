function Mult_expiry_date_single = all_contract_expiry_test(month_input, year_input) 

% -------------------- Calculate any forward months ---------------------
if month_input == 13
    month_input = 1;
    year_input = year_input + 1;
end

if month_input == 14
    month_input = 2;
    year_input = year_input + 1;
end

if month_input == 15
    month_input = 3;
    year_input = year_input + 1;
end

if month_input == 16
    month_input = 4;
    year_input = year_input + 1;
end

if month_input == 16
    month_input = 5;
    year_input = year_input + 1;
end

if month_input == 17
    month_input = 6;
    year_input = year_input + 1;
end

if month_input == 18
    month_input = 7;
    year_input = year_input + 1;
end

if month_input == 19
    month_input = 8;
    year_input = year_input + 1;
end

if month_input == 20
    month_input = 9;
    year_input = year_input + 1;
end

if month_input == 21
    month_input = 10;
    year_input = year_input + 1;
    
end


% ------------------------------------------------------------------------

        if month_input == 12   
            calc_year_single = year_input + 1;
            calc_m_single = 1;
        else
            calc_year_single = year_input;
            calc_m_single = month_input + 1;
        end
        
calc_date_single = [calc_year_single, calc_m_single, 1];
DateNumber = datenum(calc_date_single);
calc_day_1_single = weekday(DateNumber);

    if calc_day_1_single < 7
        
            calc_day_single = 6 - calc_day_1_single;
    else
            calc_day_single = 6;
    end

    
    if calc_year_single == 2014 || calc_year_single == 2019 || calc_year_single == 2022 || calc_year_single == 2025 || calc_year_single == 2030 || calc_year_single == 2033 || calc_year_single == 2041 || calc_year_single == 2044 || calc_year_single == 2049 || calc_year_single == 2052 || calc_year_single == 2055 || calc_year_single == 2057 || calc_year_single == 2060 || calc_year_single == 2068 || calc_year_single == 2071 || calc_year_single == 2076
    
            future_year_single = 1;
    else
            future_year_single = 0;
    end
    
    
    if month_input == 3 && future_year_single == 1
            
            calculated_date_single = calc_day_single + 14;
    else
            calculated_date_single = calc_day_single + 15;
    end

    Mult_expiry_date_single = datetime(calc_year_single, calc_m_single, calculated_date_single) - caldays(30);

end



