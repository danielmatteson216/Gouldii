%load('Volatility_Parameters_RangeDate.mat');
%load('Volatility_Parameters.mat');

ContractExpirations = cell(length(ActiveContracts),8);
ContractExpiration_NameArray = Contract_Name_Array;
ContractExpiration_NameArray(:,1) = strrep(ContractExpiration_NameArray(:,1),'.csv', '');
expiration_dates = ContractExpiration_NameArray(:,2);
expiration_dates = datestr(expiration_dates,'dd-mmm-yyyy');
expiration_dates = cellstr(expiration_dates);
ContractExpiration_NameArray(:,2) = expiration_dates;


a = 1;
    for j = 1:length(ActiveContracts)

        for i = a:length(ContractExpiration_NameArray)
       
            if isequal(ActiveContracts(j,1),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,1) = ContractExpiration_NameArray(i,1);   
                a = i;
            end

            if isequal(ActiveContracts(j,2),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,2) = ContractExpiration_NameArray(i,1);            
            end            
            
            if isequal(ActiveContracts(j,3),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,3) = ContractExpiration_NameArray(i,1);            
            end            
            
            if isequal(ActiveContracts(j,4),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,4) = ContractExpiration_NameArray(i,1);            
            end            
            
            if isequal(ActiveContracts(j,5),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,5) = ContractExpiration_NameArray(i,1);           
            end            
            
            if isequal(ActiveContracts(j,6),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,6) = ContractExpiration_NameArray(i,1);            
            end
            
            if isequal(ActiveContracts(j,7),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,7) = ContractExpiration_NameArray(i,1);            
            end
            
            if isequal(ActiveContracts(j,8),ContractExpiration_NameArray(i,2))
                ContractExpirations(j,8) = ContractExpiration_NameArray(i,1);            
                break;
            end
            
            
        end
    
    end

  

    