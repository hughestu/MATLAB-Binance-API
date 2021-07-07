function s = exchangeInfo(varargin)
% exchangeInfo returns info about each symbol (permissions, filters, etc.).
%
% s = pub.exchangeInfo(symbol) returns info on a specific symbol where the
% input symbol is a character row vector, e.g.:
%     >> s = pub.exchangeInfo('btcusdt');
%
% s = pub.exchangeInfo(symbols) returns the exchange info for multiple 
% symbols defined in a cell array, e.g.:
%     >> s = pub.exchangeInfo({'btcusdt','ethbtc'});
%
% s = pub.exchangeInfo() returns info on all symbols.

endPoint = '/api/v3/exchangeInfo';

assert(nargin<2,sprintf(...
    'Expected 0 or 1 input arguments. Instead there were %d.',nargin))

if nargin == 0
    
    s = webread([getBaseURL endPoint]);
    
else
    
    validateattributes(varargin{1},{'char','cell'},{'row'})
    symbol = upper(varargin{1});
    
    if isa(symbol,'cell')
        symbol = jsonencode(symbol);
        s = webread([getBaseURL endPoint '?symbols=' symbol]);
    else
        s = webread([getBaseURL endPoint '?symbol=' symbol]);
    end 

end