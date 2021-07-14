function response = sendRequest(s,endPoint,requestMethod)
% getRequest converts the input structure OPT into a matlab.net http
% request object for endpoints that require a HMAC SHA-256 signature.
%
% s is a structure of params going into the query string
% timestamp need not be included in s as this is obtained in sendRequest()
% 
% Query parameters are placed in the http body for POST requests and are
% formatted into the query string for all other requests.

% This code is so often repeated it needs to be a subfunction

% set isBody to true if you want to put the query parameters and values
% into the http body, otherwise query paramters are returned in the URL

arguments
    s                (1,1) struct
    endPoint         (1,:) char
    requestMethod    (1,:) char
end

import matlab.net.*

[akey,skey]=getkeys(s.accountName); 
s = rmfield(s,'accountName');                       % not a Q. param

if isfield(s,'recvWindow')  
    s.timestamp = pub.getServerTime();              % for hmac
end

QP = QueryParameter(s);                             % Q. params object

if isfield(s,'recvWindow')                          
    queryString = appendSignature(QP.char,skey);  	% for hmac
end


if ismember(requestMethod,{'POST'})
    
    % Put query parameters into the http body
    URL = [getBaseURL endPoint];
    
    request = http.RequestMessage(requestMethod,binanceHeader(akey),...
        http.MessageBody(queryString)...
        );
    
else
    
    % Put query parameters into the queryString
    URL = [getBaseURL endPoint '?' queryString];
    
    request = http.RequestMessage(requestMethod,binanceHeader(akey));
    
end

response = request.send(URL);

manageErrors(response)

