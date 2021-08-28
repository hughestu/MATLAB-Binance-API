function d = allOrders(symbol,OPT)
% allOrders returns all isolated margin orders (open and closed).
%
% imargin.allOrders(symbol,'orderId',id) returns orders with orderId >= id
% (up to 500 rows by default).
%
% imargin.allOrders(symbol,'startTime',t) returns orders since a startTime,
% t, where t is a datetime or a type double posixtime in milliseconds.
%
% imargin.allOrders(symbol,'endTime',t) returns orders up to an endTime, t.
%
% imargin.allOrders(___,'limit',n) returns n rows of data default: 500, 
% max: 500.
%
% Additional name-value arguments:
%   'recvWindow',t          request timeout window (1 <= t <= 60000).
%   'username',name         specifies username (see getkeys.m)

arguments
symbol                  (1,:) char	
OPT.orderId             (1,:) char
OPT.startTime           (1,1)
OPT.endTime             (1,1)
OPT.limit               (1,1) double = 500
OPT.recvWindow          (1,1) double = 5000
OPT.username         (1,:) char   = 'default'
end

OPT.symbol = upper(symbol);
OPT.isIsolated = 'TRUE';

endPoint = '/sapi/v1/margin/allOrders';
response = sendRequest(OPT,endPoint,'GET');
d = response.Body.Data;