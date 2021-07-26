function [T] = openOrders(varargin,OPT)
% openOrders returns all open orders.
%
% cmargin.openOrders() returns all open orders on the cross margin account.
%
% cmargin.openOrders(symbol) returns all open orders for a specific symbol,
% where symbol is a type char row vector.
%
% Name-value pair arguments:
%   'recvWindow',t  - request timeout window (default 5000ms, max 60000ms).
%   'username',name - specifies a different username (see getkeys.m).

arguments (Repeating)
    varargin
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} = 5000
    OPT.username (1,:) char                          = 'default'
end

assert(nargin<2,sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin))

if nargin == 1
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.symbol = upper(varargin{1});
end

OPT.isIsolated = 'FALSE';
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
    
    T = [];
    
else
    
    T = struct2table(response.Body.Data);
    
end



