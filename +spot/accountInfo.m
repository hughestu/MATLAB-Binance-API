function [T,s] = accountInfo(OPT)
% accountInfo returns the portfolio for a given account.
%
% T = spot.accountInfo() returns a table of crypotcurrencies which lists
% the asset names, the quantity of that asset free to trade, and the
% quantity which is locked (e.g. in an active order).
%
% [T,s] = spot.accountInfo() returns the original server response, s.
%
% Optional name-value pair arguments:
%   recvWindow      - request timeout window (default 5000ms, max 60000ms)
%   accountName     - specify which account to use (otherwise this uses the
%                     "default" account)

arguments
    OPT.recvWindow (1,1) {isValidrecv(OPT.recvWindow)} = 5000
    OPT.accountName (1,:) = 'default'
end

import matlab.net.*

[akey,skey] = getkeys(OPT.accountName);
OPT = rmfield(OPT,'accountName');

requestMethod = 'GET';
endPoint = '/api/v3/account';

% Format the queryString
OPT.timestamp = pub.getServerTime();
QP = QueryParameter(OPT);
queryString = QP.char;

% Generate a Signature
queryString = appendSignature(queryString,skey);
URL = [getBaseURL endPoint '?' queryString];

% Send API request
request = http.RequestMessage(requestMethod,binanceHeader(akey));
response = request.send(URL);
manageErrors(response)

s = response.Body.Data;

% Output Arg Formatting
if isstruct(s.balances)
    % Index for assets with non-zero holdings.
    idx = cellfun(@(x) str2double(x)>0,{s.balances(:).free});
    idx = or(idx,cellfun(@(x) str2double(x)>0,{s.balances(:).locked}));
    
    T = struct2table(s.balances(idx));
    T.free = cellfun(@str2double,T.free);
    T.locked = cellfun(@str2double,T.locked);
    T.asset = cellfun(@string,T.asset);
else
    T = [];
end

end