function [T] = symbolInfo(varargin)
% symbolInfo returns info about each symbol on cross margin.
%
% cmargin.symbolInfo() returns public info about all symbols on cross 
% margin, including a list of all symbols, base asset names, quote asset 
% names, isMarginTrade, isBuyAllowed and isSellAllowed.
%
% cmargin.symbolInfo(symbol) returns info for a specific symbol.
%
% Example:
%  >> T = cmargin.symbolInfo('ethbtc');

assert(nargin <= 1, ...
    sprintf('Expected 0-1 input arguments but there were %d',nargin))


if nargin == 0
    endPoint = '/sapi/v1/margin/allPairs';
    s = struct;
else
    validateattributes(varargin{1},{'char'},{'row'})
    s.symbol = upper(varargin{1});
    endPoint = '/sapi/v1/margin/pair';
end

response = sendRequest(s,endPoint,'GET','xmapikey',true);

T = struct2table(response.Body.Data);

if nargin == 0
    T.symbol = string(T{:,2});
    T.base = string(T{:,3});
    T.quote = string(T{:,4});
end

end

