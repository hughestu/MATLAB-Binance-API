function [s] = queryOrder(symbol,OPT)
% queryOrder querys an order's status.
%
% spot.queryOrder(symbol,___) returns the status for any order (open or
% filled) given the symbol and either the orderId or origClientOrderId as 
% input.
%
% spot.queryOrder(symbol,'origId',origId) uses the original order id 
% assigned by the Binance server.
%
% spot.queryOrder(symbol,'origClientOrderId',val) uses the order id 
% provided by the client in the original order request.
%
% Additional name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   accountName     - specify which account to use (otherwise this uses the
%                     "default" account)
%
%   EXAMPLE (assuming atleast one open order exists, query it): 
%    >> openOrders = spot.openOrders;
%    >> orderId = openOrders.orderId(1);
%    >> symbol = openOrders.symbol(1,:);
%    >> spot.queryOrder(symbol,'orderId',orderId)
%
%   EXAMPLE (make a market order then query the outcome):
%    >> obj = spot.newOrder('market')
%    >> set(obj,'sym','btcusdt','side','buy','quant',0.001)
%    >> s = obj.send;
%    >> spot.queryOrder('btcusdt','orderId',s.orderId)

arguments
    symbol                  (1,:) char
    OPT.orderId             (1,:) double
    OPT.origClientOrderId   (1,:) double
    OPT.recvWindow          (1,1) double	= 5000
    OPT.accountName         (1,:) char      = 'default'
end

import matlab.net.*

symbol = upper(symbol);

[akey,skey]=getkeys(OPT.accountName); OPT = rmfield(OPT,'accountName');

requestMethod = 'GET';
endPoint = '/api/v3/order';

idx = ismember({'orderId','origClientOrderId'},fieldnames(OPT));
if nnz(idx)==0
    msg = 'none';
else
    msg = 'both';
end
assert(xor(idx(1),idx(2)),...
    sprintf(['Expected either orderId or origClientOrderId as inputs ' ...
    'however %s of these inputs were provided.'],msg))

% Format the queryString
OPT.symbol = symbol;
OPT.timestamp = pub.getServerTime();
QP = QueryParameter(OPT);
queryString = QP.char;

% appendSignature
queryString = appendSignature(queryString,skey);
URL = [getBaseURL endPoint '?' queryString];

% Make API Request
request = http.RequestMessage(requestMethod,binanceHeader(akey));
response = request.send(URL);

manageErrors(response);

s = response.Body.Data;
end
