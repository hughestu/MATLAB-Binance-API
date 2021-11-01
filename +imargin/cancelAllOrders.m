function [s] = cancelAllOrders(symbol, OPT)
% cancelAllOrders cancels all orders on isolated margin account
%
% imargin.cancelAllOrders(symbol) cancels all open orders on isolated
% margin account.
%
% imargin.cancelAllOrders(___,'recvWindow',t) specifies a timeout window 
% for the request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% imargin.cancelAllOrders(___,'username',name) specifies the username as 
% per the setup in subfunction/getkeys.m


arguments (Repeating)
    symbol
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} =   5000
    OPT.username (1,:) char                             =   'default'
end

OPT.symbol = upper(symbol);

OPT.isIsolated = 'TRUE';
endPoint = '/sapi/v1/margin/openOrders';
response = sendRequest(OPT,endPoint,'DELETE');

s = response.Body.Data;
 