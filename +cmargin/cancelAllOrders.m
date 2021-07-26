function [s] = cancelAllOrders(varargin, OPT)
% cancelAllOrders cancels all orders.
%
% cmargin.cancelAllOrders() cancels all open orders on cross margin.
%
% cmargin.cancelAllOrders(symbols) cancels all open orders on cross margin
% for a specific symbol.
%
% cmargin.cancelAllOrders(___,'recvWindow',t) specifies a timeout window 
% for the request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% cmargin.cancelAllOrders(___,'username',name) specifies the username as 
% per the setup in subfunction/getkeys.m


arguments (Repeating)
    varargin
end

arguments
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} =   5000
    OPT.username (1,:) char                          =   'default'
end

assert( nargin<2, sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin ))

OPT.isIsolated = 'FALSE';

if nargin == 0
    
    openOrders = cmargin.openOrders;
    
    if isempty(openOrders)
        return
    end
    
else
    
    symbol = upper(varargin{1});
    validateattributes(symbol,{'char'},{'row'})
    OPT.symbol = upper(symbol);

end

endPoint = '/sapi/v1/margin/openOrders';

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