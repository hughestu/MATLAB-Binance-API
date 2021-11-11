function obj = newOrder(orderType)
% newOrder returns an object for making orders.
%
% obj = cmargin.newOrder(orderType) returns an order object for a specific
% orderType, where orderType can be any of the following:
% 'limit', 'market', 'stop loss limit', 'take profit limit', 'limit maker',
% 'oco' (case-insensitive).
%
% <strong>Workflow:</strong>
% (1) Create an order object for one of the supported order types.
%      >> obj = cmargin.newOrder(orderType)
% (2) Fill in the order parameters as required (for more info on the order
%     type and optional/mandatory parameters see >> help obj):
%      >> set(obj,'symbol','btcusdt',... etc)
% (3) Send the order
%      >> s = obj.send(obj)
%
%   Notes:
%   - A list of available symbols and corresponding trade permissions for
%     each symbol is available at:
%      >> s = pub.exchangeInfo
%       OR
%      >> s = cmargin.symbolInfo
%   - No symbols on the exchange currently support stop-loss or take-profit
%     orders.
%
% Example 1:
% Market order: Buy 1e-3 BTC in exchange for USDT at market price.
%  >> obj = cmargin.newOrder('market')
%  >> set(obj,'symbol','btcusdt','side','buy','quantity',1e-3)
%  >> s = obj.send;
%
% Example 2:
%  >> s = cmargin.transfer('btc',0.001,'in')% transfer btc to margin
%     cmargin.loan('btc',0.001)             % get a 0.001 btc loan
%
%     obj = cmargin.newOrder('market');     % create cross margin order obj
%     set(obj,'symbol','btcusdt','side','sell','quant',0.002)
%     s = obj.send                          % execute order
%
%     cmargin.allOrders('btcusdt','limit',1) % check last order
%     info = cmargin.accountInfo             % check cross margin portfolio
%     idx = strcmp(info.asset,'USDT');       % sell back usdt for btc
%     set(obj,'symbol','btcusdt','side','buy',...
%         'isQuote',true,'quant',info.free(idx))
%     s = obj.send
%
%     % pay off btc loan and transfer the remainder back to spot
%     cmargin.accountInfo
%     cmargin.repay('btc','max')    
%     cmargin.transfer('btc','max','out')
%
% Note: if you are not burning BNB for commission then the exact quote 
% order quantity may not fill - Binance deducts a commission from the asset 
% you receive in the trade.
%
% Example 3:
% Create a limit order for 1 LTC in exchange for BTC at 0.95 times the 
% current price in BTC:
%  >> symbol = 'ltcbtc';
%     currPrice = pub.price(symbol);
%     orderPrice = round(0.95*str2double(currPrice.price),6);
%     obj = cmargin.newOrder('limit')
%     set(obj,'symb',symbol,'side','buy','quant',1,'price',orderPrice)
%     s = obj.send;
%
% Example 4 (stop-loss-limit):
%  >> obj = cmargin.newOrder('stop loss limit')
%     set(obj,'symb','btcusdt','side','sell','quant',0.001,...
%        'stopPrice',30020,'price',30000)
%     s = obj.send
%
% See also: <a href = "https://binance-docs.github.io/apidocs/spot/en/#margin-account-new-order-trade">docs</a>

validateattributes(orderType,{'char'},{'row'})

orderType = upper(orderType);
orderType = strrep(orderType,' ','_');

switch orderType
    case 'LIMIT'
        obj = newMarginOrderObject.LIMIT;
    case 'MARKET'
        obj = newMarginOrderObject.MARKET;
    case 'STOP_LOSS_LIMIT'
        obj = newMarginOrderObject.STOP_LOSS_LIMIT;
    case 'TAKE_PROFIT_LIMIT'
        obj = newMarginOrderObject.TAKE_PROFIT_LIMIT;
    case 'LIMIT_MAKER'
        obj = newMarginOrderObject.LIMIT_MAKER;
    case 'TAKE_PROFIT'
        obj = newMarginOrderObject.TAKE_PROFIT;
    case 'STOP_LOSS'
        obj = newMarginOrderObject.STOP_LOSS;
    case 'OCO'
        obj = newMarginOrderObject.OCO;
end

assert(exist('obj','var'),...
    'The input, orderType, did not match any available order types.')


