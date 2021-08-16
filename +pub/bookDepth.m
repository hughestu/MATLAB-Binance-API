function T = bookDepth(symbol,OPT)
% bookDepth returns up to 5000 bid/ask prices and quantities for a symbol.
%
% T = pub.bookDepth(symbol) returns the orderbook for a specific symbol.
% Input symbol is a type char row vector.
%
% T = pub.bookDepth(symbol,'limit',n) returns up to n rows of bid/ask
% prices and quantities for a specific symbol (default limit: 100).
%  - Valid inputs for the limit value: 5, 10, 20, 50, 100, 500, 1000, 5000.
%
% Example 1 (get 100 rows from the current btcusdt orderbook):
%  >> T = pub.bookDepth('btcusdt');
%
% Example 2 (get 5000 rows from the BTC/USDT orderbook and then plot the 
% spread):
%  >> T = pub.bookDepth('btcusdt','limit',5000);
%     figure(), plot(T.bidPrice,cumsum(T.bidQty),'g','LineWidth',2)
%     hold on, plot(T.askPrice,cumsum(T.askQty),'r','LineWidth',2)
%     ylabel('Quantity, Q / (BTC)')
%     xlabel('Price, P / (USDT)')
%     set(gca,'fontSize',16)

arguments
    symbol      (1,:) char
    OPT.limit   (1,1) double    = 100
end

assert(ismember(OPT.limit,[5 10 20 50 100 500 1000 5000]), ...
    sprintf(['The limit can only be defined with one of '...
    'the following values:\n'...
    '5, 10, 20, 50, 100, 500, 1000, 5000.']))

OPT.symbol = upper(symbol);
QP = matlab.net.QueryParameter(OPT);


s = webread([getBaseURL '/api/v3/depth?' QP.char]);

% Convert to table
if isempty(s.bids)
    T = [];
else
    
    C = cellfun(@(x,y) [str2double(x).' str2double(y).'],s.bids,s.asks,...
        'uni',false);
    
    T = array2table(cell2mat(C),...
        'VariableNames',{'bidPrice','bidQty','askPrice','askQty'});
end

end


