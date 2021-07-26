function d = orderHistory(symbol,OPT)
% orderHistory returns a previous order given the symbol and order id.
%
% imargin.orderHistory(symbol,'orderId',id)
%
% imargin.orderHistory(symbol,'origClientOrderId',id)
%
% Additional name-value arguments:
%   'recvWindow',t          request timeout window (1 <= t <= 60000).
%   'username',name         specifies the username (see getkeys.m).

arguments
symbol                  (1,:) char	
OPT.orderId             (1,:) char	
OPT.origClientOrderId 	(1,:) char	
OPT.recvWindow          (1,1) double = 5000
OPT.username         (1,:) char   = 'default'
end

OPT.symbol = upper(symbol);
OPT.isIsolated = 'TRUE';

assert( sum(isfield(OPT,{'orderId','origClientOrderId'}))==1,...
    'Expected either an orderId OR an origClientOrderId.')

endPoint = '/sapi/v1/margin/order';
response = sendRequest(OPT,endPoint,'GET');

d = response.Body.Data;