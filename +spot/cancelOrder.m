function [s] = cancelOrder(symbol, OPT)
% cancelOrder cancels an active order given a symbol and order id.
%
% spot.cancelOrder(symbol,'orderId',orderId) cancels an order using the 
% orderId assigned by Binance.
% 
% spot.cancelOrder(symbol,'origClientOrderId',id) cancels an order using 
% the order id assigned client side.
%
% spot.cancelOrder(symbol,___,'newClientOrderId',id) specifies a new client 
% side order id.
%
% Note: either orderId or origClientOrderId are required.
%
% Optional name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   accountName     - specify which account to use (otherwise this uses the
%                     "default" account)
%
%   EXAMPLE:
%   orderId = '0123456789';
%   s = spot.cancelOrder('BTCUSDT','orderId',orderId);
%
%   origClientOrderId = '0123456789';
%   s = spot.cancelOrder('BTCUSDT','origClientOrderId',origClientOrderId)
%

arguments
    symbol                  (1,:) char
    OPT.orderId             (1,:)
    OPT.origClientOrderId   (1,:)
    OPT.newClientOrderId    (1,:)
    OPT.recvWindow          (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.accountName         (1,:) char                          = 'default'
end

import matlab.net.*

symbol = upper(symbol);

[akey,skey] = getkeys(OPT.accountName); OPT = rmfield(OPT,'accountName');
OPT.symbol = symbol;
OPT.timestamp = pub.getServerTime();

assert(isfield(OPT,'orderId') || isfield(OPT,'origClientOrderId'),...
    'Must specify either an orderId or origClientOrderId')

burl = 'https://api.binance.com';
endPoint = '/api/v3/order';
requestMethod = 'DELETE';

QP = QueryParameter(OPT);

queryString = QP.char;
queryString = appendSignature(queryString,skey);

request = http.RequestMessage(requestMethod,binanceHeader(akey));
URL = [burl endPoint '?' queryString];
response = request.send(URL);
manageErrors(response)

s = response.Body.Data; 
end

