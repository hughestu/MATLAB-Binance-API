function [T,data,response] = accountInfo(OPT)
% accountInfo returns the portfolio for a given account.
%
% T = spot.accountInfo() returns a table of crypotcurrencies which lists
% the asset names, the quantity of that asset free to trade, and the
% quantity which is locked (e.g. in an active order).
%
% [T,data] = spot.accountInfo() returns the original server response, s.
%
% Optional name-value pair arguments:
%   recvWindow   - request timeout window (default 5000ms, max 60000ms)
%   username     - specify which account to use (otherwise this uses the
%                     "default" account)

arguments
    OPT.recvWindow (1,1) {isValidrecv(OPT.recvWindow)} = 5000
    OPT.username (1,:) = 'default'
end

endPoint = '/api/v3/account';
response = sendRequest(OPT,endPoint,'GET');
data = response.Body.Data;

if isempty(data)
    T = [];
    return
end

% Output Arg Formatting
if isstruct(data.balances)
    % Index for assets with non-zero holdings.
    idx = cellfun(@(x) str2double(x)>0,{data.balances(:).free});
    idx = or(idx,cellfun(@(x) str2double(x)>0,{data.balances(:).locked}));
    
    T = struct2table(data.balances(idx));
    T.free = cellfun(@str2double,T.free);
    T.locked = cellfun(@str2double,T.locked);
    T.asset = cellfun(@string,T.asset);
else
    T = [];
end

end