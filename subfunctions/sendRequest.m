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
%
% In the absense of a recvWindow field it is implied that the request
% doesn't require authentication, so secret key is not loaded and
% accountName field is not removed as it should not be present either.

arguments
    s                (1,1) struct
    endPoint         (1,:) char
    requestMethod    (1,:) char
end

import matlab.net.*

if isfield(s,'recvWindow')
    [akey,skey]=getkeys(s.accountName); 
    s = rmfield(s,'accountName');                   % not a Q. param

    s.timestamp = pub.getServerTime();              % for hmac
else
    akey = getkeys; % when X-MBX-APIKEY is required
end

QP = QueryParameter(s);                             % Q. params object
queryString = QP.char;

if isfield(s,'recvWindow')                          
    signature = HMAC(skey,queryString);
    queryString = [queryString '&signature=' signature];  	% for hmac
end


header = matlab.net.http.HeaderField('X-MBX-APIKEY',...
    akey,'Content-Type','application/x-www-form-urlencoded');


if ismember(requestMethod,{'POST'})
    
    % Put query parameters into the http body
    URL = [getBaseURL endPoint];
    
    request = http.RequestMessage(requestMethod,header,...
        http.MessageBody(queryString)...
        );
    
else
    
    % Put query parameters into the queryString
    URL = [getBaseURL endPoint '?' queryString];
    
    request = http.RequestMessage(requestMethod,header);
    
end

response = request.send(URL);

manageErrors(response,s)

