function T = symbolInfo(varargin,OPT)
% symbolInfo returns info about each symbol on isolated margin.
%
% imargin.symbolInfo() returns public info about all symbols on isolated 
% margin, including a list of all symbols, base asset names, quote asset 
% names, isMarginTrade, isBuyAllowed and isSellAllowed.
%
% imargin.symbolInfo(symbol) returns the same info for a specific symbol.

arguments (Repeating)
   varargin
end

arguments
    OPT.username (1,:) char      = 'default'
    OPT.recvWindow  (1,1) double    = 5000
end

assert(nargin <= 1, sprintf(...
    'Expected 0 - 1 input arguments but there were %d.',nargin))

if nargin == 0

    endPoint = '/sapi/v1/margin/isolated/allPairs';

else
    
    validateattributes(varargin{1},{'char','cell'},{'row'})
    OPT.symbol = upper(varargin{1});
    endPoint = '/sapi/v1/margin/isolated/pair';
    
end
    
response = sendRequest(OPT,endPoint,'GET');

s = response.Body.Data;

T = struct2table(s);