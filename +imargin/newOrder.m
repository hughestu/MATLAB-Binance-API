function obj = newOrder(orderType)
% newOrder returns an object for making orders.
%
% obj = imargin.newOrder(orderType) instantiates the order object where 
% orderType can be any of the following:
% 'limit', 'market', 'stop loss limit', 'take profit limit', 'limit maker'
% 'oco' (case-insensitive).
%
% <strong>Workflow:</strong>
% (1) Create an order object for one of the supported order types.
%      >> obj = imargin.newOrder(orderType)
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
%   - No symbols on the exchange currently support stop-loss or take-profit
%     orders.
%
% Example 1:
% Market order: Buy 2e-3 ETH in exchange for BTC at market price.
%  >> obj = imargin.newOrder('market')
%  >> set(obj,'symbol','ethbtc','side','buy','quantity',2e-3)
%  >> s = obj.send;
%
% Example 2:
%  >> s = imargin.transfer('btc','btcusdt',0.001,'in')% transfer btc to margin
%     imargin.loan('btc','btcusdt',0.001)             % get a 0.001 btc loan
%
%     obj = imargin.newOrder('market');     % create cross margin order obj
%     set(obj,'symbol','btcusdt','side','sell','quant',0.002)
%     s = obj.send                          % execute order
%
%     info = imargin.accountInfo             % check cross margin portfolio
%     idx = strcmp(info(:,1),'BTCUSDT');     % idx for isolated account
%     info = info{idx,2};
%     set(obj,'symbol','btcusdt','side','buy',...
%         'isQuote',true,'quant',info.free(2))
%     s = obj.send
%
%     % pay off btc loan and transfer the remainder back to spot
%     imargin.accountInfo
%     imargin.repay('btc','btcusdt','max')    
%     imargin.transfer('btc','btcusdt','max','out')
%
% Note: if you are not burning BNB for commission then the exact quote 
% order quantity may not fill - Binance deducts a commission from the asset 
% you receive in the trade (see otherUsefulFunctions folder).
%
% See also: <a href = "https://binance-docs.github.io/apidocs/spot/en/#margin-account-new-order-trade">docs</a>

validateattributes(orderType,{'char'},{'row'})

orderType = upper(orderType);
orderType = strrep(orderType,' ','_');

switch orderType
    case 'LIMIT'
        obj = newMarginOrderObject.LIMIT(true);
    case 'MARKET'
        obj = newMarginOrderObject.MARKET(true);
    case 'STOP_LOSS_LIMIT'
        obj = newMarginOrderObject.STOP_LOSS_LIMIT(true);
    case 'TAKE_PROFIT_LIMIT'
        obj = newMarginOrderObject.TAKE_PROFIT_LIMIT(true);
    case 'LIMIT_MAKER'
        obj = newMarginOrderObject.LIMIT_MAKER(true);
    case 'TAKE_PROFIT'
        obj = newMarginOrderObject.TAKE_PROFIT(true);
    case 'STOP_LOSS'
        obj = newMarginOrderObject.STOP_LOSS(true);
    case 'OCO'
        obj = newMarginOrderObject.OCO(true);
end

assert(exist('obj','var')==1,...
    'The input, orderType, did not match any available order types.')


