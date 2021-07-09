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
%   accountName     - specify which account to use (otherwise this uses the
%                     "default" account)
%
%   Example:
%   cancelAllOrders('btcusdt')


arguments (Repeating)
    varargin
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} =   5000;
    OPT.accountName (1,:) char                          =   'default'
end

import matlab.net.*

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

[akey,skey] = getkeys(OPT.accountName); OPT = rmfield(OPT,'accountName');

endPoint = '/api/v3/openOrders';
requestMethod = 'DELETE';

if nargin == 1
    
    OPT.timestamp = pub.getServerTime();
    QP = QueryParameter(OPT);
    
    queryString = QP.char;
    queryString = appendSignature(queryString,skey);
    
    request = http.RequestMessage(requestMethod,binanceHeader(akey));
    URL = [getBaseURL endPoint '?' queryString];
    response = request.send(URL);
    manageErrors(response)
    
    s = response.Body.Data;
    
else
    
    if size(openOrders.symbol,1)>1
        
        symbols = unique(openOrders.symbol);
        
    elseif size(openOrders.symbol,1)==1
        
        symbols = {openOrders.symbol};
        
    end
    
    for ii = 1:numel(symbols)
        
        OPT.timestamp = pub.getServerTime();
        
        OPT.symbol = symbols{ii};
        
        QP = QueryParameter(OPT);
        
        queryString = QP.char;
        queryString = appendSignature(queryString,skey);
        
        request = http.RequestMessage(requestMethod,binanceHeader(akey));
        URL = [getBaseURL endPoint '?' queryString];
        response = request.send(URL);
        manageErrors(response)
        
        s(ii,:) = {symbols{ii} response.Body.Data};
        
        if response.StatusCode == http.StatusCode.OK
            fprintf('Deleted %s orders',symbols{ii})
        end
        
    end
    
end

