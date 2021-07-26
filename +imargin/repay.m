function varargout = repay(asset,symbol,quantity,OPT)
% repay repays a borrowed asset.
%
% imargin.repay(asset,symbol,quantity) repays a loan in isolated margin for
%  a specific asset and quantity.
%
% imargin.repay(asset,symbol,'max') repays
%
% imargin.repay(___,'recvWindow',t) specifies a timeout window for the
% request (default 5000ms), where t is a type double: 1 <= t <= 60000
%
% imargin.repay(___,'username',name) specifies the username as per the
% setup in subfunction/getkeys.m

arguments
    asset               (1,:) char
    symbol              (1,:) char
    quantity
    
    OPT.recvWindow      (1,1) double    = 5000
    OPT.username     (1,:) char      = 'default'
end

OPT.asset 	= upper(asset);
OPT.isIsolated = 'TRUE';
OPT.symbol = upper(symbol);

validateattributes(quantity,{'double','char'},{'row'})

if isa(quantity,'double')
    
    assert(numel(quantity)==1,'Numeric quantities should be scalar.')
    OPT.amount	= sprintf('%.8f',quantity);
    
else
    
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity repayable is repaid.']))
    
    T = imargin.accountInfo('username',OPT.username);
    info = T{strcmp(T(:,1),OPT.symbol),2};
    idx = ismember(info.asset,OPT.asset);
    
    owed = info.borrowed(idx) + info.interest(idx);
    
    if owed == 0
        fprintf('No %s was owed in the %s isolated margin account.\n',...
            OPT.asset,OPT.symbol)
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
    T = imargin.accountInfo('username',OPT.username);
    T = T{strcmp(T(:,1),OPT.symbol),2};
end

assert(nargout <= 3, ...
    sprintf('Expected 0-1 output arguments, but there were %d.',nargout))

if nargout == 1
    varargout{1} = T;
else
    disp(T)
end
