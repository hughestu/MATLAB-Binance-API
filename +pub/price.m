function p = price(varargin)
% price returns the latest price for a symbol or symbols.
%
% pub.price(symbol) returns symbol and price
%       e.g. >> pub.price('btcusdt')
%
% pub.price() returns symbol and price for all markets.

assert(nargin<2,sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin))

endPoint = '/api/v3/ticker/price';

if nargin == 0
    
    p = webread([getBaseURL endPoint]);

else
    
    symbol = varargin{1};
    validateattributes(symbol,{'char'},{'row'})
    
    s.symbol = upper(symbol);
    
    QP = matlab.net.QueryParameter(s);
    queryString = QP.char;
    
    p = webread([getBaseURL endPoint '?' queryString]);    
 
end