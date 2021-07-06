function [akey,skey] = getkeys_Template(accountName)
% Use this make the getkeys function.
%
% Instructions:
%
% (1) Assign the public and private keys to akey and skey, 
% respectively for one or more accounts. Modify account names as required.
%
% (2) The account name listed in the arguments block will be the account 
% for all calls to Binance. List the account you wish to use by default in
% the arguments block, ensure the name of the default account (in this 
% example the account itself is called 'default') matches one of the
% account names in the switch block
%
% (3) Finally, rename the function from getkeys_Template.m to getkeys.m
%
% You can test that the keys are correct by calling spot.accountInfo

arguments
    accountName (1,:) = 'default'
end


switch accountName
    case 'default'      % Leave named as 'default'
        
        % Public key
        akey = '';
        % Private key
        skey = ''; 
        
    case 'accountB'     % Assign any name to a second account
        
        akey = '';
        skey = '';
        
end

assert(~or(isempty(akey),isempty(skey)), ['This api request requires '...
    ' public and private keys. Refer to guidelines on Github'])