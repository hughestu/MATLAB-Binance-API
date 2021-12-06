function [s] = allOrders(symbol,OPT)
% allOrders returns (open/filled) orders for a specific account and symbol.
%
% s = spot.allOrders(symbol) returns all orders (open or filled) for a
% given symbol, where symbol is a character row vector of a trading pair on
% Binance.
%
% spot.allOrders(___,'username','userB') returns all orders from a user
% account other than the default user account, in this case from 'userB'
% (see subfunctions/getkeys.m).
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
%         username      |   char row vector

arguments
    symbol (1,:) char
    OPT.orderId (1,:) double
    OPT.startTime (1,1)
    OPT.endTime (1,1)
    OPT.limit (1,:) {isValidLimit(OPT.limit)}
    OPT.recvWindow (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.username (1,:) char = 'default';
end



% checks
if isfield(OPT,'orderId')
    assert(mod(OPT.orderId,1)==0,'orderId must be a natural number.')
end

% Change startTime to posixtime format if required
if isfield(OPT,'startTime')
    validateattributes(OPT.startTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.startTime,'datetime')      
        OPT = datetime2posix(OPT,'startTime');
    end
end

% Change endTime format if required
if isfield(OPT,'endTime')
    validateattributes(OPT.endTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.endTime,'datetime')
        OPT = datetime2posix(OPT,'endTime');
    end
end

OPT.symbol = upper(symbol);
endPoint = '/api/v3/allOrders';
response = sendRequest(OPT,endPoint,'GET');

s = response.Body.Data;

if ~isempty(s)
    s = formatOrders_struct2table(s); % output formatting
end

end

