function T = maxBorrowable(asset,symbol,OPT)
% maxBorrowable returns borrow limits.
%
% s = imargin.maxBorrowable(asset) returns a table giving the current
% "amount" borrowable for a specific asset on the default account, and the 
% max "borrowLimit" limited by the account level.
%
% s = imargin.maxBorrowable(asset,'username',name) returns borrow limits
% for isolated margin for a different binance account.
%
% Additional name-value arguments:
%   'recvWindow',t          request timeout window (1 <= t <= 60000).
%   'username',name         specifies the username (see getkeys.m)
%
% See also: <a href = "https://www.binance.com/en/margin-fee" >borrowLimits</a>

arguments
    asset
    symbol
    OPT.recvWindow          (1,1) double = 5000
    OPT.username         (1,:) char   = 'default'
end

OPT.isolatedSymbol = upper(symbol);
OPT.asset = upper(asset);
endPoint = '/sapi/v1/margin/maxBorrowable';
response = sendRequest(OPT,endPoint,'GET');
T = struct2table(response.Body.Data);

T.amount = str2double(T.amount);
T.borrowLimit = str2double(T.borrowLimit);

