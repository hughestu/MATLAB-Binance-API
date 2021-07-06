function signature = HMAC(skey,queryString)
% HMAC(skey,queryString) generates a keyed-Hash Message Authentication Code
% (HMAC) from input secret key, skey, and the queryString via the SHA-256
% hash function, H.
%
% Method: 
% (1) convert the input key to 8-bit binary format (for xor calculation).
% (2) perform xor's on each byte with ipad and opad to get ipadK and opadK
% (3) convert ipadK and opadK to decimal and complete HMAC
% (4) Perform HMAC calculation: HMAC = H([ opadK H([ipadK queryString]) ])
%
% SEE ALSO: https://en.wikipedia.org/wiki/HMAC

assert(length(skey) == 64,...
    sprintf('Expected key length to be 64, instead it was %d',length(skey)))

% Convert key from hexadecimal to binary representation, K.
K = arrayfun(@(x) bitget(uint8(skey(x)),8:-1:1),1:64,'uni',false);

% Calculate exclusive or's: xor(K,ipad) and xor(K,opad)
ipadK_binary = cellfun(@(x) xor(x,[0 0 1 1 0 1 1 0]),K,'uni',false);
opadK_binary = cellfun(@(x) xor(x,[0 1 0 1 1 1 0 0]),K,'uni',false);

% Convert to decimal
opadK = cellfun(@(x) bin2dec(sprintf('%d',x)),opadK_binary);
ipadK = cellfun(@(x) bin2dec(sprintf('%d',x)),ipadK_binary);

hmac = H([ opadK H([ipadK uint8(queryString)]) ]); % unsigned 8 bit integer

signature = sprintf('%.2x', hmac); % finally convert back to hexadecimal
end

function hash = H(Data)
% H - creates a hash value for input data of type char using SHA-256
Engine = java.security.MessageDigest.getInstance('SHA-256');
Engine.update(uint8(Data(:)));
hash = typecast(Engine.digest.', 'uint8');
end