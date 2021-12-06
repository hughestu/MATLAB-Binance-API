function [obj, varargout] = normOrder(symbol, side, normQty, OPT)
% normOrder simple market order object for a given symbol, side and normQty.
%
% obj = spot.normOrder(symbol, side, normQty) returns a prepopulated market
% order object for a given symbol, side and normQty. The order quantity,
% termed normQty, is a type double value between 0 and 1 specifying the
% order quantity in proportion to the user's available funds.
%
% In other words, if the user had 100 USDT on their spot account,
%   >> obj = spot.normOrder(symbol,side,0.5) 
% would prepare an order object with an equivalent of 50 USDT as the
% quantity (assuming that USDT is included in symbol). The prepopulated
% order object accounts for Binance Filter rules as per the notes below.
%
% [obj, info] = spot.normOrder(___, 'send', true) sends the order during
% call to spot.normOrder. The output argument, info, returns the order
% details given by Binance servers.
%
% Note: *The default value for normQ is 1
%       *Some rounding is performed based on Binance filter requirements.
%       *LOT_SIZE, MIN_NOTIONAL and MARKET_LOT_SIZE filters are dealt with.
%
% Example 1: Sell all BTC available in the default spot account for USDT at
% market value.
%   >> obj = spot.normOrder('btcusdt', 'sell'); 
%   >> obj.send()
%
% Example 2: Buy BTC for all available USDT at market value:
%   >> obj = spot.normOrder('btcusdt', 'buy') 
%   >> info = obj.send()
% 
% Example 3: Sell half of the available BTC for USDT at market value:
%   >> obj = spot.normOrder('btcusdt', 'sell', 0.5) 
%   >> info = obj.send()
%
% Example 4: Send order on call to spot.normOrder:
%   >> [obj, info] = spot.normOrder('btcusdt', 'sell', 0.5, 'send', true)
%
% Other optional name-value pair arguments:
%   recvWindow   - request timeout window (default 5000ms, max 60000ms)
%   username     - specify which account to use (otherwise this uses the
%                  "default" account)


arguments
    symbol          (1,:) char
    side            (1,:) char
    normQty         (1,1) double    = 1

    OPT.send        (1,1) logical   = false
    OPT.recvWindow  (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.username    (1,:) char      = 'default';
end

% Options
optNames = fieldnames(OPT);
optValues = struct2cell(OPT);

% Setup
e = pub.exchangeInfo(symbol).symbols;
p = str2double(pub.price(symbol).price);

assert(normQty <= 1 && normQty >=0, ...
    'Expected a value between 0 and 1 for input variable, portion.')
assert(contains(side,{'buy','sell'}),...
    'Expected input argument, side, to be either ''buy'' or ''sell''')

% Filters
minStep = max(str2double(e.filters{3}.stepSize),...
              str2double(e.filters{6}.stepSize));
minQty = max(str2double(e.filters{3}.minQty),...
             str2double(e.filters{6}.minQty));
maxQty = min(str2double(e.filters{3}.maxQty),...
             str2double(e.filters{6}.maxQty));
minNotional = str2double(e.filters{4}.minNotional);

Factor = 1.1; % Factor for the case of rapid price changes

% Prepare Order
obj = spot.newOrder('market');
set(obj, 'symbol', symbol, 'side', side,...
    'recvWindow', OPT.recvWindow, 'username', OPT.username)

spotAccount = spot.accountInfo(optNames{2},optValues{2},...
                               optNames{3},optValues{3});

% Get available qty in terms of base asset
if isequal(side,'buy')          % i.e. 'buy' the base asset.
    
    % Scenario A: get available qty of quote asset and convert to qty in
    % terms of the base asset (qtyAvailable).
    idx = strcmp(spotAccount.asset,e.quoteAsset);
    quoteAssetAvailable = spotAccount.free(idx);
    qtyAvailable = quoteAssetAvailable/p;           % convert
    
elseif isequal(side,'sell')     % i.e. 'sell' the base asset.
    
    % Scenario B: get available qty of base asset (qtyAvailable):
    idx = strcmp(spotAccount.asset,e.baseAsset);
    qtyAvailable = spotAccount.free(idx);
    
end

% Set the order quantity rounding down to the nearest minStep
obj.quantity = floor( qtyAvailable * normQty / minStep ) * minStep;

if obj.quantity > maxQty
    
    obj.quantity = floor(maxQty/minStep)*minStep;
    S = ['Input argument, normQty, was above the maximum qty allowed by\n'...
        'Binance. The order qty was decreased to the maximum to allow the order\n'...
        'to take place.'];
    warning(S,'')
    
elseif obj.quantity < minQty && qtyAvailable >= minQty
    % note: second condition means normQty will still be less than 1,
    % otherwise print 'Insufficient funds!' in the next block
    
    obj.quantity = ceil(minQty/minStep)*minStep;
    S = ['Input argument, normQty, was below the minimum qty required by\n'...
        'Binance. The order qty was increased to the minimum to allow the order\n'...
        'to take place.'];
    warning(S,'')
    
end

notionalQty = obj.quantity*p;

if notionalQty <= minNotional && qtyAvailable >= minNotional
    obj.quantity = ceil(1.1*minNotional/minStep)*minStep;
    S = ['Input argument, normQty, was below the minimum notional qty \n'...
        'required by Binance. The order qty was increased to the 1.1 * the minimum \n'...
        'to ensure the order takes place.'];
    warning(S,'')
end

orderInfo = [];
if notionalQty >= minNotional*Factor && obj.quantity > minQty
    if OPT.send
        orderInfo = obj.send();
    end
else
    disp('Insufficient funds.')
end

assert(nargout <=2, 'Too many output arguments.')

varargout{1} = orderInfo;