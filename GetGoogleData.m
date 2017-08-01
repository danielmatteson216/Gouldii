function [data] = GetGoogleData(symbol,startDate,endDate)
startDateNum = datenum(startDate);
endDateNum = datenum(endDate);

startDateStr = datestr(startDateNum, 'mmm dd, yyyy');
endDateStr = datestr(endDateNum, 'mmm dd, yyyy');

url = strcat('http://www.google.com/finance/historical?q=',symbol,'&startdate=',startDateStr,'&enddate=',endDateStr,'&output=csv');
url = strrep(url,' ','%20');

response = urlread(url);
data = textscan(response,'%s %f %f %f %f %f', 'delimiter',',','HeaderLines',1);
end
