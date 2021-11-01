function out = datetime2posix(varargin)
% t_posix = datetime2posix(t) takes a datetime array, t, and converts to 
% posixtime in milliseconds.
%
% OPT = datetime2posix(OPT,param) applies the conversion to a paramter, 
% param, in the structure, OPT.
%
% datetimes defined without a timezone use the 'local' timezone by default.

assert(nargin<=2,sprintf('Expected 1 - 2 input arguments, not %d.',nargin))

if nargin == 1
    
    t = varargin{1};
    assert(isa(t,'datetime'),'Expected single input to be a datetime')
    
    if isempty(t.TimeZone)
        t.TimeZone = 'local';
    end
    out = round(posixtime(t)*10^3);
    
else
    
    OPT = varargin{1};
    param = varargin{2};
    
    assert(isfield(OPT,param), sprintf(...
        'The input structure has no fieldnames called %s.',param))
    
    if isempty(OPT.(param).TimeZone)
        OPT.(param).TimeZone = 'local';
    end
    
    OPT.(param) = round(posixtime(OPT.(param))*10^3);
    
    out = OPT;
end

