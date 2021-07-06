function [akey,skey] = getkeys(accountName)
arguments
    accountName (1,:) = 'default'
end

switch accountName
    case 'default'
        
        % Public key
        akey = '';
        % Private key
        skey = ''; 
        
    case 'accountB'
        
        akey = '';
        skey = '';
        
end

assert(~or(isempty(akey),isempty(skey)), ['This api request requires '...
    ' public and private keys. Refer to guidelines on Github'])