function [akey,skey] = getkeys_Template(accountName)
% Use this as a template
%
% Instructions:
%
% (1) Assign the public and private keys to akey and skey, 
% respectively for one or more accounts. Modify account names as required.
%
% (2) List the account you wish to use by default in the arguments block.
% Currently, the default account is called 'default'. Ensure the name of 
% the default account matches one of the account names in the switch block.
%
% (3) Lastly, rename the function from getkeys_Template.m to getkeys.m
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
    ' public and private keys.'])