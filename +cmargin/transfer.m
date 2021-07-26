function varargout = transfer(asset,quantity,direction,OPT)
% transfer requests a transfer between spot and cross margin accounts.
%
% cmargin.transfer(asset,quantity,direction) transfers a specific quantity
% of an asset from your spot account to your margin or vice versa, where
% asset is a type char row vector of the asset, quantity is a type double
% indicating the amount of asset to transfer and direction is either 'in'
% or 'out' of cross-margin.
%
% cmargin.transfer(___,'recvWindow',t) specifies a timeout window for the
% request (default 5000ms), where t is a type double indicating the
% duration in milliseconds (1 <= t <= 60000).
%
% cmargin.transfer(___,'username',name) specifies the account name as
% per the setup in subfunction/getkeys.m
%
% Example:
%  >> cmargin.transfer('btc','max','in') transfers all available BTC from
%  your spot account into your cross margin account
%
%  >> cmargin.tranfer('btc','max','out') transfers all available BTC from
%  your cross margin account back into your spot account.
%
%  >> cmargin.transfer('btc',0.001,'in') transfer 0.001 BTC into your cross
%  margin account.


arguments
    asset           (1,:) char
    quantity
    direction       (1,:) char
    
    OPT.username (1,:) char      = 'default'
    OPT.recvWindow  (1,:)           = 5000
end

validateattributes(quantity,{'double','char'},{'row'})
assert(ismember(direction,{'in','out'}),['Invalid value for '...
    'input argument, direction. Use either ''in'' or ''out''.'])

OPT.asset = upper(asset);
OPT.type = find(strcmpi(direction,{'in','out'})); % 1-margin 2-spot


if isa(quantity,'double')   % numeric quantity specified
    
    OPT.amount	= sprintf('%.8f',quantity);
    
else	% max quantity specified
    % - need to find max qty (using other api calls).
    
    assert(isequal(quantity,'max'),sprintf(...
        ['Invalid input argument, quantity... quantity, is specified\n'...
        'either as a type double scalar value or a char row vector,\n'...
        '''max'', wherein the max quantity of the asset is transferred.']))
    
    if OPT.type == 1 % transfers max in
        
        info = spot.accountInfo('username',OPT.username);             	% get spot balances
        idx = ismember(info.asset,OPT.asset); 	% idx for relevant asset
        
        assert(any(idx),'There is no %s on your spot account.',OPT.asset)
        assert(info.free(idx)~=0,sprintf(['All %s funds on your spot'...
            'account are locked (e.g. in an open order).'],OPT.asset))
        
        OPT.amount = sprintf('%.8f',floor(info.free(idx)*1e8)*1e-8);
        
    else            % transfer max out
        
        info = cmargin.maxTransferableOut(OPT.asset,...
            'username',OPT.username);
        
        if info.amount == 0
            fprintf(['There was no %s to transfer out of your'...
                ' cross margin account.\n'],OPT.asset)
            if nargout == 1
                varargout{1} = [];
            end
            return
        else
            OPT.amount = sprintf('%.8f',floor(info.amount*1e8)*1e-8);
        end
        
    end
    
end

% Send api request
endPoint = '/sapi/v1/margin/transfer';
response = sendRequest(OPT,endPoint,'POST');

if response.StatusCode == matlab.net.http.StatusCode.OK
    info = cmargin.accountInfo('username',OPT.username);
end

% Manage outputs args
if nargout == 1
    varargout{1} = info;
else
    disp(info)
end
