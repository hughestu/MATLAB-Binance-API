function obj = newOrder(orderType)
% newOrder creates an object for making orders of a given orderType.
%
% obj = spot.newOrder(orderType) instantiates the order object where 
% orderType can be any of the following:
% 'limit', 'market', 'stop loss limit', 'take profit limit', 'limit maker'
% 'oco' (case-insensitive).
%
% <strong>Workflow:</strong>
% (1) Create an order object for one of the supported order types.
%   >> obj = spot.newOrder(orderType)
% (2) Fill in the parameters with appropriate values (see <a href =
% "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade">docs</a> for more
% info on mandatory and optional inputs corresponding to each orderType).
%   >> set(obj,'symbol','btcusdt',... etc)
% (3) Send the order
%   >> s = obj.send(obj)
%
% All order types require the following parameters:
%   symbol    - trading pair (e.g.'btcusdt')
%   side      - 'buy' or 'sell'
%   quantity  - numeric value for trade quantity (8-digit precision).
%
%   Notes:
%   - 'buy' and 'sell' mean buying or selling the symbol's base asset. The
%     base asset is on the left; hence with BTCUSDT, BTC is the asset being
%     bought or sold.
%   - Quantity is also conventionally specified in terms of the base asset.
%   - At the time of writing, Binance listed all base asset precisions at 8.
%     This function rounds all prices and quantities to 8 decimal places.
%   - The list of available symbols and corresponding trade permissions for
%     each symbol is available at:
%     s = pub.exchangeInfo
%   - No symbols on the exchange currently support stop-loss or take-profit
%     orders.
%
% Example 1:
% Market order: Buy 1e-3 BTC in exchange for USDT at market price.
% >> obj = spot.newOrder('market')
% >> set(obj,'symbol','btcusdt','side','buy','quantity',1e-3)
% >> s = obj.send;
%
% The following example is similar to example 1 but using a quote order 
% quantity instead.
%
% Example 2:
% Quote order quantity: Buy 100 USDT worth of BTC at market price.
% >> set(obj,'quantity',100,'isQuoteOrderQty',true)
% >> s = obj.send;
%
% Set isTest=true to run a test order, otherwise, trades get implemented
% normally. A response of an empty struct during a test means
% that the request would have been successful.
%
% Example 3:
% Make api request in test mode: Test order of 1 LTC in exchange for BTC at
% 0.95 times the current price in BTC
% >> symbol = 'ltcbtc';
% >> currPrice = pub.price(symbol);
% >> orderPrice = round(0.95*str2double(currPrice.price),6);
% >> obj = spot.newOrder('limit')
% >> set(obj,'symb',symbol,'side','buy','quant',1,'price',orderPrice,'isTest',1)
% >> s = obj.send;
%
% EXAMPLE (4)
% Iceberg order: A conditional order to buy or sell a large amount of
% assets in smaller predetermined quantities in order to conceal the total
% order quantity. The following order processes 100 LTC in lots of 20 LTC.
% >> obj = spot.newOrder('limit');
% >> set(obj,'symbol','ltcbtc','side','buy','quantity',100,...
%       'price',orderPrice,'icebergQty',20,'isTest',true)
% >> s = obj.send;
%
% See also: <a href = "https://binance-docs.github.io/apidocs/spot/en/#new-order-trade">docs</a>

validateattributes(orderType,{'char'},{'row'})

orderType = upper(orderType);
orderType = strrep(orderType,' ','_');

switch orderType
    case 'LIMIT'
        obj = spot.newOrderObj.LIMIT;
    case 'MARKET'
        obj = spot.newOrderObj.MARKET;
    case 'STOP_LOSS_LIMIT'
        obj = spot.newOrderObj.STOP_LOSS_LIMIT;
    case 'TAKE_PROFIT_LIMIT'
        obj = spot.newOrderObj.TAKE_PROFIT_LIMIT;
    case 'LIMIT_MAKER'
        obj = spot.newOrderObj.LIMIT_MAKER;
    case 'TAKE_PROFIT'
        obj = spot.newOrderObj.TAKE_PROFIT;
    case 'STOP_LOSS'
        obj = spot.newOrderObj.STOP_LOSS;
    case 'OCO'
        obj = spot.newOrderObj.OCO;
end

assert(exist('obj','var'),...
    'The input, orderType, did not match any available order types.')


