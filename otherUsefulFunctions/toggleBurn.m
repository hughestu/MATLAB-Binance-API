function s = toggleBurn(toggle,OPT)
% toggleBurn for turning on or off BNB fees (applies to margin and spot).
%
% toggleBurn(toggle) toggles the fee payment method for spot or margin
% depnding on input.
%
% toggle options:
%
% 'spotOn' trading fees will be paid using BNB if a sufficient amount of 
% BNB is on your spot account.
%
% 'spotOff' trading fees will be paid in terms of the asset you receive 
% from a given spot trade.
%
% 'interestOn' interest fees will be charged in terms of BNB for all cross 
% and isolated margin loans.
%
% 'interestOff' means that Binance will charge interest in terms of the
% borrowed asset, i.e. when borrowing BTC you will have to repay the 
% borrowed amount of BTC plus interest in BTC.

arguments
toggle              (1,:) char     
OPT.recvWindow      (1,1) double  	= 5000
OPT.username        (1,:) char      = 'default'
end

toggles = {'spotOn','spotOff','interestOn','interestOff'};

assert(ismember(toggle,toggles),...
    sprintf(...
    'Invalid input, toggle, with value: %s.\n\nValid toggle inputs:\n%s.'...
    ,toggle,strjoin(toggles,', ') ))

switch toggle
    case 'spotOn'
        OPT.spotBNBBurn = 'true';
    case 'spotOff'
        OPT.spotBNBBurn = 'false';
    case 'interestOn'
        OPT.interestBNBBurn = 'true';
    case 'interestOff'
        OPT.interestBNBBurn = 'false';
end

endPoint = '/sapi/v1/bnbBurn';
response = sendRequest(OPT,endPoint,'POST');
s = response.Body.Data;

