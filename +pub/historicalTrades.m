function [T,s] = historicalTrades(symbol,OPT)
% historicalTrades returns older market trades (up to 1000 per request).
%  
% T = pub.historicalTrades(symbol) returns the last 500 trades in a table
% giving the tradefor the
% symbol, where symbol is a type char row vector.
%
% T = pub.historicalTrades(___,'limit',val) returns up to val historical
% trades (val is valid in the range 1 <= val <= 1000).
%
% T = pub.historicalTrades(___,'fromId',tradeId) returns trades subsequent 
% to the input tradeId, where the first trade on a symbol has tradeId = 1
% and subsequent tradeId's increase consecutively by 1.
%
% [T,s] = pub.historicalTrades(___) returns the unformatted server response
% as a structure, s.


arguments
    symbol      (1,:) char      
    OPT.limit   (1,1) double    = 500
    OPT.fromId 	(1,1) double
end

import matlab.net.*
OPT.symbol = upper(symbol);

akey =  getkeys();

endPoint = '/api/v3/historicalTrades';
requestMethod = 'GET';

QP = QueryParameter(OPT);
queryString = QP.char;

request = http.RequestMessage(requestMethod,binanceHeader(akey));
URL = [getBaseURL endPoint '?' queryString];
response = request.send(URL);
manageErrors(response)

s = response.Body.Data;

T = struct2table(s);
T.price = str2double(T.price);
T.qty = str2double(T.qty);
T.quoteQty = str2double(T.quoteQty);

time = T.time;
T.time = [];

T = table2timetable(T,'RowTimes',...
    datetime(time*1e-3,'ConvertF','posixtime','TimeZone','local'));


