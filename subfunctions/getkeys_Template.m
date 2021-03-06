function [pubKey,secKey] = getkeys_Template(username)
% Use this as a template
%
% Instructions:
%
% (1) Assign the public and private keys to pubKey and secKey below. You
% can have more than one user, just use the additional case in the
% switch block and add keys as required for additional users.
%
% (2) The default user is called 'default' itself. Ensure that one of 
% the usernames in the switch block is also called 'default'.
%
% (3) Lastly, rename the function from getkeys_Template.m to getkeys.m
%
% You can test that the keys are correct by calling:
%  >> [~,~,response] = spot.accountInfo;
% and then verifying that the response gives an HTTP 200 status code.

arguments
    username (1,:) char = 'default'     % must leave named as 'default'
end


switch username
    case 'default'      % username is nominally called 'default'
        
        % Public key
        pubKey = '';
        % Private key
        secKey = ''; 

        % Assign any username for other sets of keys

    case 'userB'     
        % functions or objects which require HMAC SHA-264 authentication  
        % will access userB by adding the name-value pair argument
        % 'username','userB'. When the optional name-value pair
        % argument isn't included in those functions, they will use the
        % 'default' user account credentials.
        
        % Public key
        pubKey = '';
        % Private key
        secKey = '';
        
end

assert(~or(isempty(pubKey),isempty(secKey)), ['This api request requires '...
    ' public and private keys.'])
assert(and(length(secKey)==64,length(pubKey)==64),...
    'Expected key lengths to be 64, check that you copied the full key')

