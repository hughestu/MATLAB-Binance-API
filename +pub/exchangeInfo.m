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


if nargin == 0
    s = webread('https://api.binance.com/api/v3/exchangeInfo');
    
elseif nargin == 1
    
    validateattributes(varargin{1},{'char','cell'},{'row'})
    symbol = upper(varargin{1});
    
    if isa(symbol,'char')
        s = webread([...
            'https://api.binance.com/api/v3/exchangeInfo?symbol=' symbol]);
    else
        symbol = jsonencode(symbol);
        s = webread([...
            'https://api.binance.com/api/v3/exchangeInfo?symbols=' symbol]);
    end
        
else
    error('Expected 0 or 1 input arguments. Instead there were %d.',nargin)
end