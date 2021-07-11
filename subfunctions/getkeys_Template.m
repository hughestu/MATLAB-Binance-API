function [pubKey,secKey] = getkeys_Template(accountName)
% Use this as a template
%
% Instructions:
%
% (1) Assign the public and private keys to pubKey and secKey below. You
% can have more than one account, just use the additional case in the
% switch block and add keys as required for additional accounts.
%
% (2) The default account is called 'default' itself. Ensure that one of 
% the account names in the switch block is also called 'default'.
%
% (3) Lastly, rename the function from getkeys_Template.m to getkeys.m
%
% You can test that the keys are correct by calling:
%  >> [~,~,response] = spot.accountInfo;
% and then verifying that the response gives an HTTP 200 status code.


arguments
    accountName (1,:) char = 'default' % must leave named as 'default'
end


switch accountName
    case 'default'      % accountName is nominally called 'default'
        
        % Public key
        pubKey = '';
        % Private key
        secKey = ''; 

        % Assign any name to further account you wish to include

    case 'accountB'     
        % functions or objects which require HMAC SHA-264 authentication  
        % can access accountB by adding the name-value pair argument
        % 'accountName','accountB'. If the optional name-value pair
        % argument isn't included then the default account is used.
        
        % Public key
        pubKey = '';
        % Private key
        secKey = '';
        
end

assert(~or(isempty(pubKey),isempty(secKey)), ['This api request requires '...
    ' public and private keys.'])
assert(and(length(secKey)==64,length(pubKey)==64),...
    'Expected key lengths to be 64, check that you copied the full key')

