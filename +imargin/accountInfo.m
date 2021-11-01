function [T,s] = accountInfo(OPT)
% accountInfo returns the portfolio for all isolated margin accounts.
%
% imargin.accountInfo() returns a list of assets in the default user's 
% isolated margin account.
%
% imargin.accountInfo('username',name) specifies the username as 
% per the setup in subfunction/getkeys.m
%
% imargin.accountInfo(___,'recvWindow',t) specifies a timeout window for 
% the request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).

arguments
    OPT.username (1,:) char      = 'default'
    OPT.recvWindow  (1,1) double    = 5000
end

endPoint = '/sapi/v1/margin/isolated/account';
response = sendRequest(OPT,endPoint,'GET');

data = response.Body.Data;
s = data.assets;

% Table formatting
if ~isempty(s)

     for ii = 1:size(s,1)
         b = s(ii).baseAsset;
         q = s(ii).quoteAsset;
         
         T{ii,1} = s(ii).symbol;
         
         T{ii,2} = [struct2table(b,'AsArray',1); struct2table(q,'AsArray',1)];
         
         fnames = T{ii,2}.Properties.VariableNames;
         for jj = [3:8 10]
            T{ii,2}.(fnames{jj}) = str2double(T{ii,2}.(fnames{jj}));
         end
         
     end
    
else
    
    T = [];
    s = [];
    
end
