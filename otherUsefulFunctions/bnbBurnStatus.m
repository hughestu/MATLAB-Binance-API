function response = bnbBurnStatus(OPT)
% bnbBurnStatus

arguments
   OPT.recvWindow   (1,1) double    = 5000 
   OPT.username     (1,:) char     	= 'default'
end

endPoint = '/sapi/v1/bnbBurn';
response = sendRequest(OPT,endPoint,'GET');

end

