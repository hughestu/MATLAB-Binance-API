function [s] = openOrders(symbol,OPT)
% openOrders returns all open orders on an isolated margin account.
%
% imargin.openOrders(symbol) returns all open orders for a specific 
% isolated margin account, where symbol is a type char row vector.
%
% Name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   username        - specify which username (otherwise this uses the
%                     "default" user account)

arguments
    symbol          (1,:) char
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} = 5000
    OPT.username (1,:) char                          = 'default'
end

OPT.symbol = upper(symbol);
OPT.isIsolated = 'TRUE';
endPoint = '/sapi/v1/margin/openOrders';
response = sendRequest(OPT,endPoint,'GET');

if isempty(response.Body.Data)
    
    if isfield(OPT,'symbol')
        fprintf(['\n\nNo active orders exist for <strong>%s</strong> on'...
            ' the <strong>%s</strong> account!\n'],OPT.symbol,OPT.username)
    else
        fprintf(['\n\n There are no open orders on the '...
            '<strong>%s</strong> account!\n'],OPT.username)
    end
    
    s = [];
    
else
    
    s = struct2table(response.Body.Data);
    
end



