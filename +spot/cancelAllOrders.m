function [s] = cancelAllOrders(varargin, OPT)
% cancelAllOrders cancels all active orders on a symbol including OCO's.
%
% spot.cancelAllOrders(symbol) cancels all open orders on your account for
% a given symbol, where symbol is a type char row vector.
%
% spot.cancelAllOrders() cancels all open orders. This requires atleast 
% one cancel order request per symbol ( there are no endpoints to 
% cancel every order using a single api request, so spot.cancelAllOrders()
% iterates through each symbol via spot.cancelAllOrder(symbol) ).
%
% Optional name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   username     - specify which account to use (otherwise this uses the
%                     "default" account)
%
%   Example:
%   cancelAllOrders('btcusdt')


arguments (Repeating)
    varargin
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} =   5000;
    OPT.username (1,:) char                          =   'default'
end


assert( nargin<2, sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin ))

if nargin == 0
    
    openOrders = spot.openOrders;
    
    if isempty(openOrders)
        return
    end
    
else
    
    symbol = upper(varargin{1});
    validateattributes(symbol,{'char'},{'row'})
    OPT.symbol = upper(symbol);

end

endPoint = '/api/v3/openOrders';

if nargin == 1
    
    response = sendRequest(OPT,endPoint,'DELETE');
    
    s = response.Body.Data;
    
else
    
    if size(openOrders.symbol,1)>1
        
        symbols = unique(openOrders.symbol);
        
    elseif size(openOrders.symbol,1)==1
        
        symbols = {openOrders.symbol};
        
    end
    
    for ii = 1:numel(symbols)
        
        OPT.symbol = symbols{ii};
        
        response = sendRequest(OPT,endPoint,'DELETE');
        
        s(ii,:) = {symbols{ii} response.Body.Data};
        
        if response.StatusCode == matlab.net.http.StatusCode.OK
            fprintf('Deleted %s orders.\n',symbols{ii})
        end
        
    end
    
end

