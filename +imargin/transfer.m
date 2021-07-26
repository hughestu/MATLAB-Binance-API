function varargout = transfer(asset,symbol,quantity,direction,OPT)
% transfer requests a transfer between spot and isolated margin accounts.
%
% imargin.transfer(asset,symbol,quantity,direction) transfers a specific
% quantity of an asset from your spot account to one of your isolated
% margin accounts or vice versa.
%
% imargin.transfer(asset,symbol,direction,'max') transfers the maximum
% available quantity to/from one of your isolated margin accounts.
%
% imargin.transfer(___,'recvWindow',t) specifies a timeout window for
% the request (default 5000ms), where t is a type double indicating the
% duration in milliseconds (1 <= t <= 60000).
%
% imargin.transfer(___,'username',name) specifies the user account name
% as per the setup in subfunction/getkeys.m
%
% Example 1
% Transfer 0.001 BTC into your ETHBTC isolated margin account:
%  >> imargin.transfer('btc','ethbtc',);
%
% Example 2
% Transfer 0.001 BTC out of your margin account and back to your spot
% account:
%  >> imargin.transfer('btc',0.001,'btcusdt','out');

arguments
    asset           (1,:) char
    symbol          (1,:) char
    quantity
    direction       (1,:) char
    OPT.username (1,:) char      = 'default'
    OPT.recvWindow  (1,:)           = 5000
end

validateattributes(quantity,{'char','double'},{'row'})
assert(ismember(direction,{'in','out'}),['Invalid value for '...
    'input argument, direction. Use either ''in'' or ''out''.'])

% Put query params into the input stucture
OPT.asset = upper(asset);
OPT.symbol = upper(symbol);

idx = strcmpi(direction,{'in','out'}); % 1-margin 2-spot
clientDirections = {'SPOT','ISOLATED_MARGIN'};
OPT.transTo = clientDirections{~idx};
OPT.transFrom = clientDirections{idx};

% quantity
if isa(quantity,'double')
    
    OPT.amount	= sprintf('%.8f',quantity);
    
else
    % max quantity in or out
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity of the asset is borrowed.']))
    
    switch direction
        case 'in'
            info = spot.accountInfo('username',OPT.username);
            idx = ismember(info.asset,OPT.asset);
            
            if ~any(idx)
                fprintf(['No %s was free to transfer from the spot '...
                    'account into the %s isolated margin account.\n'],...
                    OPT.asset,OPT.symbol)
                if nargout == 1
                    varargout{1} = [];
                end
                return
            end
            OPT.amount = sprintf('%.8f',floor(info.free(idx)*1e8)*1e-8);
            
        case 'out'
            info = imargin.maxTransferableOut(OPT.asset,OPT.symbol,...
                'username',OPT.username);
            
            if info.amount == 0
                fprintf(['No %s was free to transfer out of the %s '...
                    'isolated margin account.\n'],OPT.asset,OPT.symbol)
                if nargout == 1
                    varargout{1} = info;
                else
                    disp(info)
                end
                return
            end
            OPT.amount = sprintf('%.8f',info.amount);
    end
    
end

% Send api request
endPoint = '/sapi/v1/margin/isolated/transfer';
response = sendRequest(OPT,endPoint,'POST');

if response.StatusCode == matlab.net.http.StatusCode.OK
    T = imargin.accountInfo('username',OPT.username);
    T = T{strcmp(T(:,1),OPT.symbol),2};
end

assert(nargout <= 1, ...
    sprintf('Expected 0-1 output arguments, but there were %d.',nargout))

if nargout == 1
    varargout{1} = T;
else
    disp(T)
end
