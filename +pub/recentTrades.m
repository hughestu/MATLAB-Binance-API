function T = recentTrades(symbol,OPT)
% recentTrades returns a list of recent trades for a specific symbol.
%
% T = pub.recentTrades(symbol) returns the last 500 trades for the symbol. 
% Input variable, symbol, is a character row vector. 
%
% T = pub.recentTrades(symbol,'limit',val) specifies the number of trades
% to include in the server response.
%
%   Example:
%   Get the last 100 trades on the BTC/USDT pair:
%    >> T = pub.recentTrades('btcusdt','limit',100)
%

arguments
    symbol      (1,:) char
    OPT.limit   (1,1) double    = 500
end


OPT.symbol = upper(symbol);
QP = matlab.net.QueryParameter(OPT);

s = webread([getBaseURL '/api/v3/trades?' QP.char]);

T = struct2table(s);
T.price = str2double(T.price);
T.qty = str2double(T.qty);
T.quoteQty = str2double(T.quoteQty);
