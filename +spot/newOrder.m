function [obj] = newOrder(orderType)
% newOrder creates an object for making orders of a given orderType.
%
% obj = spot.newOrder(orderType) instantiates the order object where 
% orderType can be any of the following:
% 'limit', 'market', 'stop loss limit', 'take profit limit', 'limit maker'
% 'oco' (case-insensitive).
%
% <strong>Workflow:</strong>
% (1) Create an order object for one of the supported order types.
%      >> obj = spot.newOrder(orderType)
% (2) Fill in the order parameters as required (for more info on the order
%     type and optional/mandatory parameters see >> help obj):
%      >> set(obj,'symbol','btcusdt',... etc)
% (3) Send the order
%      >> s = obj.send(obj)
%
%   Notes:
%   - 'buy' and 'sell' mean buying or selling the symbol's base asset. The
%     base asset is on the left; hence with BTCUSDT, BTC is the asset being
%     bought or sold.
%   - Quantity is also conventionally specified in terms of the base asset.
%   - Orders allow up to 8 digits of precision for quantities and prices.
%   - A list of available symbols and corresponding trade permissions for
%     each symbol is available at:
%      >> s = pub.exchangeInfo
%   - No symbols on the exchange currently support stop-loss or take-profit
%     orders.
%
% Example 1:
% Market order: Buy 1e-3 BTC in exchange for USDT at market price.
%  >> obj = spot.newOrder('market')
%  >> set(obj,'symbol','btcusdt','side','buy','quantity',1e-3)
%  >> s = obj.send;
%
% The following example continues from example 1 but using a quote order 
% quantity instead.
%
% Example 2:
% Quote order quantity: Buy 100 USDT worth of BTC at market price.
%  >> set(obj,'quantity',100,'isQuoteOrderQty',true)
%  >> s = obj.send;
%
% Set isTest=true to run a test order, otherwise, trades get implemented
% normally. An output of an empty struct during a test means that the
% request would have been successful.
%
% Example 3:
% Make api request in test mode: Test order of 1 LTC in exchange for BTC at
% 0.95 times the current price in BTC
%  >> symbol = 'ltcbtc';
%  >> currPrice = pub.price(symbol);
%  >> orderPrice = round(0.95*str2double(currPrice.price),6);
%  >> obj = spot.newOrder('limit')
%  >> set(obj,'symb',symbol,'side','buy','quant',1,'price',orderPrice,'isTest',1)
%  >> s = obj.send;
%
% Example 4 (stop-loss-limit):
%  >> obj = spot.newOrder('stop loss limit')
%  >> set(obj,'symb','btcusdt','side','sell','quant',0.001,...
%        'stopPrice',30020,'price',30000)
%  >> s = obj.send
%
% Example 5 (icebergQty):
% An iceberg order is a conditional order to buy or sell a large amount of
% assets in smaller predetermined quantities in order to conceal the total
% order quantity. The following order processes 100 LTC in lots of 20 LTC.
%  >> obj = spot.newOrder('limit');
%  >> set(obj,'symbol','ltcbtc','side','buy','quantity',100,...
%        'price',orderPrice,'icebergQty',20,'isTest',true)
%  >> s = obj.send;
%
% See also: <a href = "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade">docs</a>
%

validateattributes(orderType,{'char'},{'row'})

orderType = upper(orderType);
orderType = strrep(orderType,' ','_');

switch orderType
    case 'LIMIT'
        obj = newSpotOrderObject.LIMIT;
    case 'MARKET'
        obj = newSpotOrderObject.MARKET;
    case 'STOP_LOSS_LIMIT'
        obj = newSpotOrderObject.STOP_LOSS_LIMIT;
    case 'TAKE_PROFIT_LIMIT'
        obj = newSpotOrderObject.TAKE_PROFIT_LIMIT;
    case 'LIMIT_MAKER'
        obj = newSpotOrderObject.LIMIT_MAKER;
    case 'TAKE_PROFIT'
        obj = newSpotOrderObject.TAKE_PROFIT;
    case 'STOP_LOSS'
        obj = newSpotOrderObject.STOP_LOSS;
    case 'OCO'
        obj = newSpotOrderObject.OCO;
end

assert(exist('obj','var')==1,...
    'The input, orderType, did not match any available order types.')
