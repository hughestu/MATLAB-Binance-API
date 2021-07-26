function varargout = loan(asset,quantity,OPT)
% loan requests a loan for a specific asset and quantity.
%
% cmargin.loan(asset,quantity) requests a loan for a specific asset and
% quantity.
%
% cmargin.loan(asset,'max') request the maximum loan for specific asset.
%
% cmargin.loan(___,'recvWindow',t) specifies a timeout window for the
% request (default 5000ms), where t is a type double indicating the
% duration in milliseconds (1 <= t <= 60000).
%
% cmargin.loan(___,'username',name) specifies the userame as per the setup
% in subfunction/getkeys.m
%
% <a href = "https://www.binance.com/en/support/faq/360041505471">cross-margin rules</a>

arguments
    asset               (1,:) char
    quantity
    
    OPT.recvWindow      (1,1) double    = 5000
    OPT.username     (1,:) char      = 'default'
end

OPT.asset 	= upper(asset);
validateattributes(quantity,{'double','char'},{'row'})

if isa(quantity,'double')
    
    OPT.amount	= sprintf('%.8f',quantity);
    
else
    
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity of the asset is borrowed.']))
    
    info = cmargin.maxBorrowable(OPT.asset,'username',OPT.username);
    
    OPT.amount = sprintf('%.8f',info.amount);
    
end


endPoint = '/sapi/v1/margin/loan';
response = sendRequest(OPT,endPoint,'POST');

if response.StatusCode == matlab.net.http.StatusCode.OK
    info = cmargin.accountInfo('username',OPT.username);
end

assert(nargout <= 1, ...
    sprintf('Expected 0-1 output arguments, but there were %d.',nargout))

if nargout == 1
    varargout{1} = info;
else
    disp(info)
end