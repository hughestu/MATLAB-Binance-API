function varargout = repay(asset,quantity,OPT)
% repay repays a borrowed asset.
%
% cmargin.repay(asset,quantity) repays a loan in cross margin for a 
% specific asset and quantity.
%
% cmargin.repay(asset,'max') fully repays an asset assuming the account has
% a sufficient quantity of that asset to repay.
%
% cmargin.repay(___,'recvWindow',t) specifies a timeout window for the 
% request (default 5000ms), where t is a type double: 1 <= t <= 60000
%
% cmargin.repay(___,'username',name) specifies the username as per the
% setup in subfunction/getkeys.m
%
% <a href = "https://www.binance.com/en/support/faq/360041505471">cross-margin rules</a>

arguments
    asset               (1,:) char
    quantity           

    OPT.recvWindow      (1,1) double    = 5000
    OPT.username     (1,:) char      = 'default'
end

validateattributes(quantity,{'double','char'},{'row'})
OPT.asset 	= upper(asset);

if isa(quantity,'double')
    
    assert(numel(quantity)==1,'Numeric quantities should be scalar.')
    OPT.amount	= sprintf('%.8f',quantity);
    
else
    
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity repayable is repaid.']))
    
    info = cmargin.accountInfo('username',OPT.username);
    idx = ismember(info.asset,OPT.asset);
    
    owed = info.borrowed(idx) + info.interest(idx);
    
    if owed == 0
        fprintf('No outstanding loans for %s.\n',OPT.asset)
        if nargout == 1
            varargout{1} = info;
        else
            disp(info)
        end
        
        return
    end

    OPT.amount = sprintf('%.8f',owed);
    
end

endPoint = '/sapi/v1/margin/repay';
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
