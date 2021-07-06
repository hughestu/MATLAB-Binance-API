function p = price(varargin)
% price returns the latest price for a symbol or symbols.
%
% pub.price(symbol) returns symbol and price
%       e.g. >> public.price('btcusdt')
%
% pub.price() returns symbol and price for all markets.

baseURL = 'https://api.binance.com';
endPoint = '/api/v3/ticker/price';

if nargin == 1
    
    symbol = varargin{1};
    validateattributes(symbol,{'char'},{'row'})
    s.symbol = upper(symbol);
    
    QP = matlab.net.QueryParameter(s);
    queryString = QP.char;
    
    p = webread([baseURL endPoint '?' queryString]);
    
elseif nargin == 0
    
    p = webread([baseURL endPoint]);
    
else
    
    error('Expected 0 or 1 input arguments. Instead there were %d.',nargin)
    
end