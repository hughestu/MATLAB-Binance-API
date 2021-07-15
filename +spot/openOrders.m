function [s] = openOrders(varargin,OPT)
% openOrders returns all open orders on a symbol.
%
% spot.openOrders() returns all open orders on the default spot account.
%
% spot.openOrders(symbol) returns all open orders for a specific symbol,
% where symbol is a type char row vector.
%
% Name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   accountName     - specify which account to use (otherwise this uses the
%                     "default" account)

arguments (Repeating)
    varargin
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} = 5000
    OPT.accountName (1,:) char                          = 'default'
end

assert(nargin<2,sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin))

if nargin == 1
    
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.symbol = upper(varargin{1});
    
end

endPoint = '/api/v3/openOrders';
response = sendRequest(OPT,endPoint,'GET');

if isempty(response.Body.Data)
    
    if isfield(OPT,'symbol')
        fprintf(['\n\nNo active orders exist for <strong>%s</strong> on'...
            ' the <strong>%s</strong> account!\n'],OPT.symbol,OPT.accountName)
    else
        fprintf(['\n\n There are no open orders on the '...
            '<strong>%s</strong> account!\n'],OPT.accountName)
    end
    
    s = [];
    
else
    
    s = struct2table(response.Body.Data);
    
end



