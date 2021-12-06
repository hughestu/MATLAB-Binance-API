function [T] = accountTradeList(symbol,OPT)
% accountTradeList returns your trades for a specific account and symbol.
%
% s = spot.accountTradeList(symbol) returns your trade history for a
% specific symbol (note: input symbol is mandatory).
%
% s = spot.accountTradeList(symbol,'startTime',startTime) returns your
% trade history from startTime onwards (t >= startTime). startTime can be
% a datetime or a numeric datatype (where numerics are posixtime in ms).
%
% s = spot.accountTradeList(symbol,'endTime',endTime) returns your trade
% history from before endTime (t <= endTime). endTime can be a datetime or
% a numeric datatype.
%
% s = spot.accountTradeList(symbol,'fromId',orderId) returns orders >=
% orderID, otherwise the most recent orders are returned. Note, this
% function doesn't accept start or end times when an orderId is specified.
%
% s = spot.accountTradeList(___,'limit',limit) specifies the upper limit
% for number of trades returned (min: 1, max: 1000, default: 500).
%
% s = accountTradeList(___,'recvWindow',recvWindow) specifies duration in
% milliseconds for a request timeout.
%
%   EXAMPLE:
%   Request btc/usdt trades which were implemented on the default account:
%    >> s = spot.accountTradeList('btcusdt');
%
%   Request the first two btc/usdt trades implemented on the default
%   account from yesterday:
%    >> s = spot.accountTradeList('btcusdt','startTime',...
%               datetime('yesterday'),'limit',2)

arguments
    symbol          (1,:) char
    OPT.startTime 	(1,1)
    OPT.endTime     (1,1)
    OPT.fromId      (1,1) double
    OPT.limit       (1,1) double
    OPT.recvWindow  (1,1) {isValidrecv(OPT.recvWindow)}     = 5000
    OPT.username (1,:) char                              = 'default'
end


if isfield(OPT,'limit')
    validateattributes(OPT.limit,{'numeric'},{'<=',1000,'>=',1})
end

if isfield(OPT,'fromId')
    % When using fromId, the user cannot specify a startTime or endTime
    assert(~isfield(OPT,'startTime') || ~isfield(OPT,'endTime'),...
        'Cannot specify fromId with a startTime and/or an endTime')
end

if isfield(OPT,'startTime')
    validateattributes(OPT.startTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.startTime,'datetime')    
        OPT = datetime2posix(OPT,'startTime');
    end
end

if isfield(OPT,'endTime')
    validateattributes(OPT.endTime,{'numeric','datetime'},{'scalar'})
    if isa(OPT.endTime,'datetime')
        OPT = datetime2posix(OPT,'endTime');
    end
end

% Send api request
OPT.symbol = upper(symbol);
endPoint = '/api/v3/myTrades';
response = sendRequest(OPT,endPoint,'GET');

% Format output args
if isempty(response.Body.Data)
    T = [];
    return
end

s = struct2table(response.Body.Data);
temp = cellfun(@str2double,s{:,5:8});

T = table(s.symbol, s.id, s.orderId, temp(:,1), temp(:,2), temp(:,3),...
    temp(:,4), s.commissionAsset,...
    datetime(s.time/1000, 'ConvertF', 'posixtime', 'TimeZone', 'local'),...
    'VariableNames', {'symbol','id','orderId','price','qty','quoteQty'...
    ,'commission','commissionAsset','time'} );


