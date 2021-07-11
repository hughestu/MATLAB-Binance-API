function out = datetime2posix(varargin)
% t_posix = datetime2posix(t) takes a datetime array, t, and converts to 
% posixtime in milliseconds (conversion uses the users local timezone).
%
% OPT = datetime2posix(OPT,param) applies the conversion to a paramter, 
% param, in the structure, OPT.

assert(nargin<=2,sprintf('Expected 1 - 2 input arguments, not %d.',nargin))

if nargin == 1
    
    t = varargin{1};
    assert(isa(t,'datetime'),'Expected single input to be a datetime')
    t.TimeZone = 'local';
    out = posixtime(t)*10^3;
    
else
    
    OPT = varargin{1};
    param = varargin{2};
    
    assert(isfield(OPT,param), sprintf(...
        'The input structure has no fieldnames called %s.',param))
    
    OPT.(param).TimeZone = 'local';
    OPT.(param) = posixtime(OPT.(param))*10^3;
    
end

