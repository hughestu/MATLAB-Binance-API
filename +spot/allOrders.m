function s = allOrders(symbol,OPT)
% allOrders returns (open/filled) orders for a specific account and symbol.
%
% s = spot.allOrders(symbol) returns all orders (open or filled) for a
% given symbol, where symbol is a character row vector of a trading pair on
% Binance.
%
% spot.allOrders(___,'accountName','accountB') returns all orders from
% an account other than the default account, in this case from 'accountB'.
% 
% spot.allOrders(___,'orderId',n) returns all orders for a trading symbol
% with orderId >= n
%
% spot.allOrders(___,'startTime',t) returns all orders which were placed
% on or after time, t, where t is posixTime in milliseconds. 
%
% spot.allOrders(___,'limit',limit) specifies a limited number of orders
% where limit can be from 1 up to a maximum of 1000.
%
%   Example:
%    >> s = spot.allOrders('btcusdt')
%
%   Example:
%    >> s = spot.allOrders('btcusdt','orderId',1)
%
%   Example to request all open orders for BTCUSDT in last 24 hours.
%    >> startTime = datetime('today')-hours(12));
%       spot.allOrders('btcusdt','startTime',startTime)
%
%   Name-value pair arguments:
%
%           Name        |            Value       
%   ------------------------------------------------------
%         orderId       |   integer id from binance
%         startTime     |   numeric (posix) or datetime
%         endTime       |   numeric (posix) or datetime
%         limit         |   integer value from 1 -  1000
%         recvWindow    |   integer value from 1 - 60000
%         accountName   |   char row vector

arguments
    symbol (1,:) char
    OPT.orderId (1,:) double
    OPT.startTime (1,1) {isValidTime(OPT.startTime)}
    OPT.endTime (1,1) {isValidTime(OPT.endTime)}
    OPT.limit (1,:) {isValidLimit(OPT.limit)}
    OPT.recvWindow (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.accountName (1,:) char = 'default';
end

import matlab.net.*
symbol = upper(symbol);

% checks
if isfield(OPT,'orderId')
    assert(mod(OPT.orderId,1)==0,'orderId must be a natural number.')
end

% Change startTime to posixtime format if required
if isfield(OPT,'startTime')
    validateattributes(OPT.startTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.startTime,'datetime')
        warning(['To use datetimes, please specify your timezone inside'...
            ' %s and/or remove this warning'],mfilename)
        % select your time zone ( refer to doc('posixtime') )
        OPT.startTime.TimeZone = 'UTC'; 
        OPT.startTime = posixtime(OPT.startTime)*1000; 
    end
end

% Change endTime format if required
if isfield(OPT,'endTime')
    validateattributes(OPT.endTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.endTime,'datetime')
        warning(['To use datetimes, please specify your timezone inside'...
            ' %s and/or remove this warning'],mfilename)
        OPT.endTime.TimeZone = 'UTC'; % similarly
        OPT.endTime = posixtime(OPT.endTime)*1000; 
    end
end

OPT.timestamp = pub.getServerTime();
[akey,skey] = getkeys(OPT.accountName); OPT = rmfield(OPT,'accountName');
OPT.symbol = symbol;


endPoint = '/api/v3/allOrders';
requestMethod = 'GET';

QP = QueryParameter(OPT);
queryString = QP.char;
queryString = appendSignature(queryString,skey);

request = http.RequestMessage(requestMethod,binanceHeader(akey));
URL = [burl endPoint '?' queryString];
response = request.send(URL);
manageErrors(response)

s = response.Body.Data;

s = formatOrders_struct2table(s); % (I personally find this easier).

end

