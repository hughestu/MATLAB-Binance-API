function [T,data] = accountInfo(OPT)
% accountInfo returns the cross margin account portfolio.
%
% cmargin.accountInfo() returns a list of assets in the default margin
% account.
%
% cmargin.accountInfo('username',name) specifies the username as per the
% the setup in subfunction/getkeys.m
%
% cmargin.accountInfo(___,'recvWindow',t) specifies a timeout window for 
% the request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% Example (transfer 0.001 btc into cross-margin and get accountInfo
%  >> cmargin.transfer('btc',0.001,'in');
%     cmargin.accountInfo

arguments
    OPT.username (1,:) char      = 'default'
    OPT.recvWindow  (1,1) double    = 5000
end

endPoint = '/sapi/v1/margin/account';
response = sendRequest(OPT,endPoint,'GET');

data = response.Body.Data;
s = data.userAssets;

% Table formatting
tableData = str2double(...
    [{s.free}; {s.locked}; {s.borrowed}; {s.interest}; {s.netAsset}].' );

idx = any(tableData~=0,2); % select rows with non-zero asset quantities

if any(idx)
    T = array2table(tableData(idx,:),'VariableNames',...
    {'free','locked','borrowed','interest','netAsset'});
    T = [table(string({s(idx).asset}).','VariableNames',{'asset'}) T];
else 
    T = array2table(zeros(1,6),'VariableNames',...
        {'asset','free','locked','borrowed','interest','netAsset'});
end

