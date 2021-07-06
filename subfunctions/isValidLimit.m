function [] = isValidLimit(limit)
arguments
    limit (1,1)
end

if isa(limit,'char') || isa(limit,'string')
    limit = str2double(limit);
end

try
assert(limit<1000 && limit>1,...
    'Expected input "limit" to be in the range 1 to 1000')
catch ME
    rethrowAsCaller(ME)
end