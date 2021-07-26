function s = maxTransferableOut(asset,OPT)
% maxTransferableOut returns current withdrawal limits.

arguments
    asset
    OPT.recvWindow  	(1,1) double = 5000
    OPT.username        (1,:) char   = 'default'
end

OPT.asset = upper(asset);
endPoint = '/sapi/v1/margin/maxTransferable';
response = sendRequest(OPT,endPoint,'GET');
s = response.Body.Data;

s.amount = str2double(s.amount);