function T = loan(asset,symbol,quantity,OPT)
% loan requests an loan for a specific asset, symbol and quantity.
%
% imargin.loan(asset,symbol,quantity) requests a loan on the isolated
% margin account for a specific asset, quantity and symbol. The symbol
% indicates which market the loan is isolated on.
%
% imargin.loan(asset,symbol,'max') request the maximum loan for a specific 
% asset and symbol.
%
% Example 1 (transfer 0.001 BTC to a margin account isolated to the BTCUSDT
% pair, request the max loan (approx. 10x) of BTC, the repay the loan and
% interest):
%  >> imargin.transfer(
%
% imargin.loan(___,'recvWindow',t) specifies a timeout window for the 
% request (default 5000ms), where t is a type double indicating the 
% duration in milliseconds (1 <= t <= 60000).
%
% imargin.loan(___,'username',name) specifies the username as per the setup
% in subfunction/getkeys.m
%
% SEE: <a href = "https://academy.binance.com/en/glossary/isolated-margin">isolated-margin</a>

arguments
    asset               (1,:) char
    symbol              (1,:) char
    quantity            
    
    OPT.recvWindow      (1,1) double    = 5000
    OPT.username     (1,:) char      = 'default'
end

validateattributes(quantity,{'double','char'},{'row'})

OPT.asset      = upper(asset);
OPT.symbol 	   = upper(symbol);
OPT.isIsolated = 'TRUE';

if isa(quantity,'double')
    
    OPT.amount	= sprintf('%.8f',quantity);
    
else
    
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity of the asset is borrowed.']))
    
    info = imargin.maxBorrowable(OPT.asset,OPT.symbol,...
        'username',OPT.username);
    
    OPT.amount = sprintf('%.8f',info.amount);
    
end

endPoint = '/sapi/v1/margin/loan';
response = sendRequest(OPT,endPoint,'POST');

if response.StatusCode == matlab.net.http.StatusCode.OK
    info = imargin.accountInfo('username',OPT.username);
    idx = ismember(info(:,1), OPT.symbol);
    info = info{idx,2};
end

T = info;

if nargout == 0
    disp(info)
end