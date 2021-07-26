function s = maxTransferableOut(asset,symbol,OPT)
% maxTransferableOut returns withdrawal limits.


arguments
    asset
    symbol
    OPT.recvWindow          (1,1) double = 5000
    OPT.username         (1,:) char   = 'default'
end

OPT.asset = upper(asset);
OPT.isolatedSymbol = upper(symbol);
endPoint = '/sapi/v1/margin/maxTransferable';
response = sendRequest(OPT,endPoint,'GET');
s = response.Body.Data;

s.amount = str2double(s.amount);