function [s] = cancelOrder(symbol, OPT)
% cancelOrder cancels an order given the symbol and order id.
%
% imargin.cancelOrder(symbol,'orderId',id) cancels an order using the 
% server side order id.
%
% imargin.cancelOrder(symbol,'origClientOrderId',id) cancels order using 
% the client side order id (specified during order creation).
%
% imargin.cancelOrder(___,'newClientOrderId',clientId) specifies a new
% client side order id.
%
% imargin.cancelOrder(___,'recvWindow',t) specifies a timeout window for the
% request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% imargin.cancelOrder(___,'username',name) specifies the username as per
% the setup in subfunction/getkeys.m
% 
arguments
    symbol                  (1,:) char
    OPT.orderId             (1,:)
    OPT.origClientOrderId   (1,:)
    OPT.newClientOrderId    (1,:)
    OPT.recvWindow          (1,:) {isValidrecv(OPT.recvWindow)} = 5000;
    OPT.username         (1,:) char                          = 'default'
end

assert(isfield(OPT,'orderId') || isfield(OPT,'origClientOrderId'),...
    'Must specify either an orderId or origClientOrderId')

OPT.isIsolated = 'TRUE';

OPT.symbol = upper(symbol);
endPoint = '/sapi/v1/margin/order';

response = sendRequest(OPT,endPoint,'DELETE');

s = response.Body.Data; 

end