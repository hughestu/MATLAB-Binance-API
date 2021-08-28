function response = sendRequest(s,endPoint,requestMethod,OPT)
% sendRequest perpares and sends all api requests.
%
% sendRequest(s,endPoint,requestMethod) 
%
% sendRequest(___,'xmapikey',true) adds public key into the header for
% public endpoints that require it.
%
% Input s is a structure of name-value parameters which either go in the 
% queryString or http body. Input s may also include a username field 
% meaning that the request requires api key authentication. In this 
% scenario, sendRequest appends a secure signature to the query string.
%
% When HTTP status codes other than 200 are returned, the manageErrors.m
% function parses the server response for important info (server error
% message, status code, filter rule broken, etc.) and throws an error with
% said info.
%
% Query parameters are placed in the http body for POST requests while all
% other request types place them in the queryString.
%
% * * sendRequest is being adapted into all api requests * *

arguments
    s                (1,1) struct
    endPoint         (1,:) char
    requestMethod    (1,:) char
    OPT.xmapikey     (1,1) logical = false
end

import matlab.net.*

% Use authentication when structure contains username field
if isfield(s,'username')
    
    [akey,skey] = trykeys(s.username);
    
    s = rmfield(s,'username');                      % not a Q. param
    
    s.timestamp = pub.getServerTime();              % for hmac
    
elseif OPT.xmapikey

    akey = trykeys(); % when X-MBX-APIKEY is required.
    
end

QP = QueryParameter(s);                             % Q. params object
queryString = QP.char;

if exist('skey','var')
    signature = HMAC(skey,queryString);
    queryString = [queryString '&signature=' signature];  	% for hmac
end

if exist('akey','var')
    header = http.HeaderField('X-MBX-APIKEY',...
        akey,'Content-Type','application/x-www-form-urlencoded');
else
    header = http.HeaderField('Content-Type',...
        'application/x-www-form-urlencoded');
end


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

end

function varargout = trykeys(varargin)
    if nargin ==1
        username = varargin{1};
    else
        username = 'default';
    end

    try
        if nargout == 2
            [akey,skey]=getkeys(username);
            varargout{1} = akey;
            varargout{2} = skey;
        else
           varargout{1} =getkeys(username);
        end
    catch ME
        if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
            msg = sprintf(['Undefined function getkeys.m\n\n'...
                'To setup a getkeys.m file, refer to either the <a href='...
                '"https://github.com/hughestu/MATLAB-Binance-API"'...
                '>GitHub docs</a>\nor the template function in; '...
                'subfunctions/getkeys_Template.m']);
            throwAsCaller(MException('MATLAB:UndefinedFunction',msg))
        else
            rethrow(ME)
        end
    end
end




