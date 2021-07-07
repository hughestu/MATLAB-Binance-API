function s = bookTicker(varargin)
% bookTicker returns the best bid/ask price & qty for a symbol or symbols.
%
% s = pub.bookTicker(symbol) returns the bid/ask prices and quantities
% for a specific symbol.
%
% s = pub.bookTicker() returns all bid/ask prices and quantities for the
% exchange.
%
% Example:
%   >>  s = pub.bookTicker('BTCUSDT')

endPoint = '/api/v3/ticker/bookTicker';

if nargin==1
    
    validateattributes(varargin{1},{'char'},{'row'})
    OPT.symbol = upper(varargin{1});
    
    QP = matlab.net.QueryParameter(OPT);
    queryString = QP.char;
    
    s = webread([getBaseURL endPoint '?' queryString]);
    
else
    
    s = webread([getBaseURL endPoint]);
end



