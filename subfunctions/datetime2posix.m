function OPT = datetime2posix(OPT,param)
    assert(isfield(OPT,param), sprintf(...
        'The input structure has no fieldnames called %s.',param))
    OPT.(param).TimeZone = 'local';
    OPT.(param) = posixtime(OPT.(param))*10^3;
end

