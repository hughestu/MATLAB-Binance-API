function [s] = cancelOrder(symbol, OPT)
% cancelOrder cancels an order given the symbol and order id.
%
% cmargin.cancelOrder(symbol,'orderId',id) cancels order using the server
% order id.
%
% cmargin.cancelOrder(symbol,'origClientOrderId',id) cancels order using 
% the client order id (specified during order creation).
%
% cmargin.cancelOrder(___,'newClientOrderId',clientId) specifies a new
% clientside order id number.
%
% cmargin.cancelOrder(___,'recvWindow',t) specifies a timeout window for 
% the request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% cmargin.cancelOrder(___,'username',name) specifies the username (see
% usernames in getkeys.m)
 
arguments
    symbol                  (1,:) char
    OPT.orderId             (1,:)
    OPT.origClientOrderId   (1,:)
    OPT.newClientOrderId    (1,:)
    OPT.recvWindow          (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.username            (1,:) char                          = 'default'
end

assert(isfield(OPT,'orderId') || isfield(OPT,'origClientOrderId'),...
    'Must specify either an orderId or origClientOrderId')

OPT.isIsolated = 'FALSE';

OPT.symbol = upper(symbol);
endPoint = '/sapi/v1/margin/order';

response = sendRequest(OPT,endPoint,'DELETE');

s = response.Body.Data; 

end

